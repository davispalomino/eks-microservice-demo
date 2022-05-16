resource "aws_ecr_repository" "this" {
  name                 = "${var.project}-${var.env}-${var.service}"
  image_tag_mutability = var.image_tag_mutability

  encryption_configuration {
    encryption_type = "AES256"
    kms_key         = var.kms_key
  }
  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
}