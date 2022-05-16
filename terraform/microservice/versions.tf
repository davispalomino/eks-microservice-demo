terraform {
  required_version = ">= 0.13.0"

  required_providers {
    kubernetes = ">= 2.0"
    random     = ">= 3.1"
    aws        = ">= 3.19"
  }

}

provider "kubernetes" {
  config_path = "/tmp/kubectl/${var.project}-${var.env}-cluster"
}
