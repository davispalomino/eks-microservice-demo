module "securitygroup-cluster" {
  source = "./modules/vpc-securitygroup"

  project = var.project
  env     = var.env
  service = var.service
  vpc_id  = data.aws_vpc.this.id
}

resource "aws_security_group_rule" "cluster_00" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.securitygroup-cluster.values.id
}

resource "aws_security_group_rule" "cluster_01" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = module.securitygroup-cluster.values.id
  security_group_id        = module.securitygroup-cluster.values.id
}