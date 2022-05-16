resource "aws_iam_role" "this" {
  name = "${var.project}-${var.env}-${var.service}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ${jsonencode(var.aws_services)}
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Name    = "${var.project}-${var.env}-${var.service}"
    Project = var.project
    Service = var.service
    Env     = var.env
  }
}