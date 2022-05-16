#!/bin/bash

EKS_NAME=$1
EKS_ROLE=$2
EKS_VERSION=$3
AWS_REGION=$4
DIR_HOME=$5

apk add --no-cache jq python3 py3-pip curl gettext && pip3 install --upgrade pip && pip3 install --no-cache-dir awscli && rm -rf /var/cache/apk/*

curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.24.0/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl
kubectl version --client

AWS_ID=$(aws sts get-caller-identity | jq -r .Account)

export KUBECONFIG=/tmp/${EKS_NAME}

# generar kubeconfig
aws eks update-kubeconfig --name ${EKS_NAME} --region ${AWS_REGION}

# instalar aws-auth
export EKS_ROLE=${EKS_ROLE} AWS_ID=${AWS_ID} && envsubst < ${DIR_HOME}/aws-auth-cm.yaml | kubectl apply -f -

# instalar metrics-server
kubectl apply -f  https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.3.7/components.yaml

# instalar cluster-autoscaler
EKS_VERSION=$(curl -s https://api.github.com/repos/kubernetes/autoscaler/releases | grep tag_name | grep cluster-autoscaler | grep ${EKS_VERSION} | cut -d '"' -f4 | cut -d "-" -f3 | head -1)
export EKS_NAME=${EKS_NAME} EKS_VERSION=${EKS_VERSION} && envsubst < ${DIR_HOME}/cluster-autoscaler-autodiscover.yaml | kubectl apply -f -
kubectl -n kube-system annotate deployment.apps/cluster-autoscaler cluster-autoscaler.kubernetes.io/safe-to-evict="false" --overwrite

# instalar container insights
curl https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/quickstart/cwagent-fluent-bit-quickstart.yaml | sed 's/{{cluster_name}}/'${EKS_NAME}'/;s/{{region_name}}/'${AWS_REGION}'/;s/{{http_server_toggle}}/"On"/;s/{{http_server_port}}/"2020"/;s/{{read_from_head}}/"Off"/;s/{{read_from_tail}}/"Off"/' | kubectl apply -f - 
