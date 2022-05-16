module "eks-cluster" {
  source = "./modules/eks-cluster"

  project                   = var.project
  env                       = var.env
  service                   = var.service
  role_arn                  = module.role.values.arn
  subnet_ids                = [for subnet in data.aws_subnets.private.ids : subnet]
  security_group_ids        = [module.securitygroup-cluster.values.id]
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  endpoint_public_access    = var.endpoint_public_access
  endpoint_private_access   = var.endpoint_private_access
  eks_version               = var.eks_version

  encryption_config = [
    {
      key_arn   = aws_kms_key.this.arn
      resources = ["secrets"]
    }
  ]
}