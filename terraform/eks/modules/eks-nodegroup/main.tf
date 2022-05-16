resource "aws_eks_node_group" "this" {
  cluster_name    = var.cluster_name
  node_group_name = var.node_group_name
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids

  launch_template {
    version = var.launch_template_version
    id      = var.launch_template_id
  }

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  ami_type      = var.ami_type
  capacity_type = var.capacity_type
  # disk_size      = var.disk_size
  instance_types = var.instance_types
  tags           = var.tags

  force_update_version = var.force_update_version

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}