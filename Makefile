PROJECT=nttdata
ENV=dev
SERVICE=devops
AWS_REGION=us-west-2
AWS_ACCOUNT=$(shell aws sts get-caller-identity | jq -r .Account)

IMAGE=${AWS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com/${PROJECT}-${ENV}-${SERVICE}:$(shell date '+%Y%m%d%H')

PORT_MS=80
HEALTH=/health

terraform_base:
	@rm -rf terraform/base/main.auto.tfvars
	@echo 'project = "$(PROJECT)"' >> terraform/base/main.auto.tfvars
	@echo 'env = "$(ENV)"' >> terraform/base/main.auto.tfvars
	@docker run --rm -v $(PWD)/terraform/base:/workspace -w /workspace hashicorp/terraform:0.15.5 init
	@docker run --rm -v $(PWD)/terraform/base:/workspace -w /workspace  \
	  -e "AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID)" \
      -e "AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY)" \
      -e "AWS_DEFAULT_REGION=$(AWS_REGION)" \
	hashicorp/terraform:0.15.5 plan -out template.plan
	@docker run --rm -v $(PWD)/terraform/base:/workspace -w /workspace hashicorp/terraform:0.15.5 show -json template.plan > $(PWD)/terraform/base/template.json

terraform_eks:
	@rm -rf terraform/eks/kubectl
	@rm -rf terraform/eks/main.auto.tfvars
	@echo 'project = "$(PROJECT)"' >> terraform/eks/main.auto.tfvars
	@echo 'service = "cluster"' >> terraform/eks/main.auto.tfvars
	@echo 'env = "$(ENV)"' >> terraform/eks/main.auto.tfvars
	@docker run --rm -v $(PWD)/terraform/eks:/workspace -w /workspace hashicorp/terraform:0.15.5 init
	@docker run --rm -v $(PWD)/terraform/eks:/workspace -w /workspace  \
	  -e "AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID)" \
      -e "AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY)" \
      -e "AWS_DEFAULT_REGION=$(AWS_REGION)" \
	hashicorp/terraform:0.15.5 plan -out template.plan
	@docker run --rm -v $(PWD)/terraform/eks:/workspace -w /workspace hashicorp/terraform:0.15.5 show -json template.plan  > $(PWD)/terraform/eks/template.json

terraform_microservice:
	@mkdir -p /tmp/kubectl/ && aws eks update-kubeconfig --name ${PROJECT}-${ENV}-cluster --region ${AWS_REGION} --kubeconfig /tmp/kubectl/${PROJECT}-${ENV}-cluster && export KUBECONFIG=/tmp/kubectl/${PROJECT}-${ENV}-cluster && kubectl config use-context arn:aws:eks:${AWS_REGION}:${AWS_ACCOUNT}:cluster/${PROJECT}-${ENV}-cluster
	@rm -rf terraform/microservice/kubectl
	@rm -rf terraform/microservice/main.auto.tfvars
	@echo 'project = "$(PROJECT)"' >> terraform/microservice/main.auto.tfvars
	@echo 'service = "$(SERVICE)"' >> terraform/microservice/main.auto.tfvars
	@echo 'env = "$(ENV)"' >> terraform/microservice/main.auto.tfvars
	@echo 'port = "$(PORT_MS)"' >> terraform/microservice/main.auto.tfvars
	@echo 'health = "$(HEALTH)"' >> terraform/microservice/main.auto.tfvars
	@echo 'image = "${AWS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com/${PROJECT}-${ENV}-${SERVICE}@$(shell aws ecr describe-images --repository-name dataops-dev-devops --query 'sort_by(imageDetails,& imagePushedAt)[-1].imageDigest' --output text)"' >> terraform/microservice/main.auto.tfvars
	@echo 'aws_region = "$(AWS_REGION)"' >> terraform/microservice/main.auto.tfvars
	@cd terraform/microservice && terraform init && terraform plan -out template.plan && terraform show -json template.plan  > $(PWD)/terraform/microservice/template.json

terraform_ecr:
	@rm -rf terraform/ecr/main.auto.tfvars
	@echo 'project = "$(PROJECT)"' >> terraform/ecr/main.auto.tfvars
	@echo 'service = "$(SERVICE)"' >> terraform/ecr/main.auto.tfvars
	@echo 'env = "$(ENV)"' >> terraform/ecr/main.auto.tfvars
	@cd terraform/ecr && terraform init && terraform plan -out template.plan && terraform show -json template.plan  > $(PWD)/terraform/ecr/template.json

terraform_ingress:
	@aws eks update-kubeconfig --name $(PROJECT)-$(ENV)-cluster --region $(AWS_REGION) && kubectl config use-context arn:aws:eks:$(AWS_REGION):$(AWS_ACCOUNT):cluster/$(PROJECT)-$(ENV)-cluster &> /dev/null
	@helm repo add traefik https://helm.traefik.io/traefik &> /dev/null
	@helm upgrade --install traefik traefik/traefik -f k8s/traefik.yaml 
	@sed 's/{{project}}/$(PROJECT)/g; s/{{env}}/$(ENV)/g; s/{{service}}/$(SERVICE)/g' k8s/ingressroute.yml | kubectl apply -f - &> /dev/null

docker_build:
	@docker build -f docker/app/Dockerfile -t $(PROJECT)-$(ENV)-$(SERVICE) .
	@aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com
	@docker tag ${PROJECT}-${ENV}-${SERVICE} ${IMAGE} && docker push ${IMAGE}

docker_postman:
	@echo "\033[92m[INFO] TEST - NEWMAN & POSTMAN\033[0m"
	@docker build -f docker/postman/Dockerfile -t ${PROJECT}-container-postman . &> /dev/null
	@docker build -f docker/app/Dockerfile -t $(PROJECT)-$(ENV)-$(SERVICE) . &> /dev/null
	@export SERVICE="${SERVICE}" && export ENV="${ENV}" && export PROJECT="${PROJECT}" && export TF_VAR_PORT=80 && export TF_VAR_PATH_HEALTH=/health && docker-compose up --abort-on-container-exit --exit-code-from newman

docker_pylint:
	@docker build -f docker/pylint/Dockerfile -t ${PROJECT}-container-pylint .
	@docker run --rm -v $(PWD)/app:/app ${PROJECT}-container-pylint

docker_checkov:
	@docker run --rm -t -v $(PWD)/terraform:/terraform -w /terraform bridgecrew/checkov -o cli -f /terraform/base/template.json -f /terraform/ecr/template.json -f /terraform/eks/template.json --hard-fail-on HARD_FAIL_ON

infra_test:
	@echo "\033[92m[INFO] TEST - CHECKOV POLICY AS CODE\033[0m"
	@make terraform_base &> /dev/null
	@make terraform_eks &> /dev/null
	@make terraform_ecr &> /dev/null
	@make terraform_microservice &> /dev/null
	@make docker_checkov

infra_deploy:
# INFRA BASE
	@echo "\033[92m[INFO] CREATE INFRA-BASE VPC\033[0m"
	@docker run --rm -v $(PWD)/terraform/base:/workspace -w /workspace \
	  -e "AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID)" \
      -e "AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY)" \
      -e "AWS_DEFAULT_REGION=$(AWS_REGION)" \
    hashicorp/terraform:0.15.5 apply -auto-approve &> /dev/null
	@echo "\033[92m[INFO] CREATE INFRA-EKS\033[0m"
	@docker run --rm -v $(PWD)/terraform/eks:/workspace -w /workspace \
	  -e "AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID)" \
      -e "AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY)" \
      -e "AWS_DEFAULT_REGION=$(AWS_REGION)" \
    hashicorp/terraform:0.15.5 apply -auto-approve &> /dev/null
	@echo "\033[92m[INFO] CREATE INFRA-ECR\033[0m"
	@cd $(PWD)/terraform/ecr && terraform apply -auto-approve &> /dev/null
	@echo "\033[92m[INFO] CREATE INFRA-MICROSERVICE\033[0m"
	@cd $(PWD)/terraform/microservice && terraform apply -auto-approve &> /dev/null
	@echo "\033[92m[INFO] CREATE EKS-INGRESS\033[0m"
	@make terraform_ingress &> /dev/null

imagen_scan:
	@echo "\033[92m[INFO] SCANING IMGEN\033[0m"
	@docker run --rm -t -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image --exit-code 0 $(PROJECT)-$(ENV)-$(SERVICE)

quickstart:
# Newman & Postman
	@make docker_postman
# Scanning image
	@make imagen_scan
# Create ECR
	@echo "\033[92m[INFO] CHECK ECR\033[0m"
	@make terraform_ecr &> /dev/null
	@cd $(PWD)/terraform/ecr && terraform apply -auto-approve &> /dev/null
# Push Image
	@echo "\033[92m[INFO] BUILD APP\033[0m"
	@make docker_build &> /dev/null
# Test infra
	@make infra_test
# Deploy infra
	@make infra_deploy
	@echo "\033[92m[INFO] Configure /etc/hosts\033[0m"
	@dig +short $(shell kubectl get service traefik -o=json | jq -r '.status.loadBalancer.ingress[0].hostname') | awk '{print $$0 " $(SERVICE).$(PROJECT).com"}'
	@echo "\033[92m[INFO] FINISH DEPLOYMENT\033[0m"


container_update:
# Newman & Postman
	@make docker_postman
# Scanning image
	@make imagen_scan
# Create ECR
	@echo "\033[92m[INFO] CHECK ECR\033[0m"
	@make terraform_ecr &> /dev/null
	@cd $(PWD)/terraform/ecr && terraform apply -auto-approve &> /dev/null
# Push Image
	@echo "\033[92m[INFO] BUILD APP\033[0m"
	@make docker_build &> /dev/null
# Deploy microservice
	@echo "\033[92m[INFO] DEPLOY CONTAINER \033[0m"
	@make terraform_microservice &> /dev/null
	@cd $(PWD)/terraform/microservice && terraform apply -auto-approve &> /dev/null
# Edit /etc/host
	@echo "\033[92m[INFO] Configure /etc/hosts\033[0m"
	@dig +short $(shell kubectl get service traefik -o=json | jq -r '.status.loadBalancer.ingress[0].hostname') | awk '{print $$0 " $(SERVICE).$(PROJECT).com"}'
	@echo "\033[92m[INFO] FINISH DEPLOYMENT\033[0m"

