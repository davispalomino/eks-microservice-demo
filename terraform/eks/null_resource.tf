resource "null_resource" "this" {
  provisioner "local-exec" {
    command = "bash ${path.module}/k8s.sh $EKS_NAME $EKS_ROLE $EKS_VERSION $AWS_REGION $DIR_HOME"
    environment = {
      EKS_NAME    = module.eks-cluster.values.id
      EKS_ROLE    = module.role.values.arn
      EKS_VERSION = var.eks_version
      AWS_REGION  = data.aws_region.this.name
      DIR_HOME    = path.module
    }
  }
  depends_on = [null_resource.kubectl]
}

resource "null_resource" "kubectl" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "apk update && apk upgrade && apk add bash curl"
  }
}