module "role" {
  source = "./modules/iam-role"

  project      = var.project
  env          = var.env
  service      = var.service
  aws_services = ["eks.amazonaws.com", "ec2.amazonaws.com"]
}

resource "aws_iam_role_policy_attachment" "this" {
  count      = length(var.policy_arn)
  policy_arn = var.policy_arn[count.index]
  role       = module.role.values.name
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.project}-${var.env}-${var.service}"
  role = module.role.values.name
}

resource "aws_iam_openid_connect_provider" "this" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cluster.certificates.0.sha1_fingerprint]
  url             = module.eks-cluster.values.identity.0.oidc.0.issuer
}