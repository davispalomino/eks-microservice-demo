data "aws_caller_identity" "this" {}
data "aws_region" "this" {}
data "aws_eks_cluster" "this" {
  name = contains(split("-", var.template_name), "cluster") == true ? var.template_name : "${var.template_name}-cluster"
}
data "aws_iam_policy_document" "assume_role_with_oidc" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type = "Federated"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.this.account_id}:oidc-provider/oidc.eks.${data.aws_region.this.name}.amazonaws.com/id/${split("/", data.aws_eks_cluster.this.identity[0].oidc[0].issuer)[4]}"
      ]
    }
    condition {
      test     = "StringEquals"
      variable = "oidc.eks.${data.aws_region.this.name}.amazonaws.com/id/${split("/", data.aws_eks_cluster.this.identity[0].oidc[0].issuer)[4]}:sub"
      values   = [var.xray == false ? "system:serviceaccount:${var.namespace == "default" ? "default" : var.namespace}:${var.template_name}-${var.service}" : "system:serviceaccount:${var.namespace}:xray-daemon"]
    }
    condition {
      test     = "StringEquals"
      variable = "oidc.eks.${data.aws_region.this.name}.amazonaws.com/id/${split("/", data.aws_eks_cluster.this.identity[0].oidc[0].issuer)[4]}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {

  name                 = "${var.template_name}-${var.service}"
  path                 = var.path
  max_session_duration = var.max_session_duration

  permissions_boundary = var.role_permissions_boundary_arn

  assume_role_policy = data.aws_iam_policy_document.assume_role_with_oidc.json
}


resource "aws_iam_role_policy_attachment" "custom" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}


resource "aws_iam_policy" "this" {
  name        = "${var.template_name}-${var.service}"
  path        = var.path
  description = "Policy del MS ${var.template_name}-${var.service}"

  policy = var.policy
}