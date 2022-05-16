resource "aws_security_group" "this" {
  name_prefix = "${substr(var.project, 0, 2)}${substr(var.env, 0, 2)}${substr(var.service, 0, 2)}-"
  description = var.description
  vpc_id      = var.vpc_id

  tags = {
    Name    = "${var.project}-${var.env}-${var.service}"
    Project = var.project
    Service = var.service
    Env     = var.env
  }

  lifecycle {
    create_before_destroy = true
  }
}