resource "aws_eks_cluster" "this" {
  name                      = "${var.project}-${var.env}-${var.service}"
  role_arn                  = var.role_arn
  version                   = var.eks_version
  enabled_cluster_log_types = var.enabled_cluster_log_types

  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    security_group_ids      = var.security_group_ids
  }

  dynamic "encryption_config" {
    for_each = toset(var.encryption_config)

    content {
      provider {
        key_arn = encryption_config.value["key_arn"]
      }
      resources = encryption_config.value["resources"]
    }
  }

  tags = {
    Name    = "${var.project}-${var.env}-${var.service}"
    Project = var.project
    Env     = var.env
    Service = var.service
  }

  timeouts {
    create = var.timeout_create
    delete = var.timeout_delete
    update = var.timeout_update
  }
}