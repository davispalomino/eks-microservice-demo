resource "kubernetes_service_account" "this" {
  metadata {
    name = "${var.project}-${var.env}-${var.service}"
    annotations = {
      "eks.amazonaws.com/role-arn" = module.service-role.role_arn
    }
  }
}

module "service-role" {
  source = "./modules/service-role"

  template_name = "${var.project}-${var.env}"
  service       = var.service
  policy        = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "dynamodb:*",
        "kms:*",
        "secretsmanager:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}