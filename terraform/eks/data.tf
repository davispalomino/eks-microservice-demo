data "aws_region" "this" {}

data "aws_ami" "this" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amazon-eks-node-${var.eks_version}-v*"]
  }
}

data "tls_certificate" "cluster" {
  url = module.eks-cluster.values.identity.0.oidc.0.issuer
}

# capturar VPC
data "aws_vpc" "this" {
  tags = {
    Name = "${var.project}-${var.env}"
  }
}

# capturar id de subnets public
data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }

  tags = {
    Name = "${var.project}-${var.env}-public"
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }

  tags = {
    Name = "${var.project}-${var.env}-private"
  }
}