module "eks-nodegroup" {
  source = "./modules/eks-nodegroup"

  cluster_name            = "${var.project}-${var.env}-${var.service}"
  node_role_arn           = module.role.values.arn
  subnet_ids              = [for subnet in data.aws_subnets.private.ids : subnet]
  capacity_type           = var.capacity_type
  desired_size            = var.desired_size
  max_size                = var.max_size
  min_size                = var.min_size
  instance_types          = var.instance_types
  launch_template_version = aws_launch_template.this.latest_version
  launch_template_id      = aws_launch_template.this.id

  tags = {
    Project = var.project
    Env     = var.env
    Service = var.service
  }

  depends_on = [
    aws_iam_role_policy_attachment.this,
    module.eks-cluster
  ]
}