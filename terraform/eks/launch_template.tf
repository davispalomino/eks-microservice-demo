resource "aws_launch_template" "this" {
  name_prefix = "${substr(var.project, 0, 2)}${substr(var.env, 0, 2)}${substr(var.service, 0, 2)}-"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = var.disk_size
    }
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Project = var.project
      Env     = var.env
      Service = var.service
    }
  }

  tag_specifications {
    resource_type = "volume"

    tags = {
      Project = var.project
      Env     = var.env
      Service = var.service
    }
  }

  tag_specifications {
    resource_type = "spot-instances-request"

    tags = {
      Project = var.project
      Env     = var.env
      Service = var.service
    }
  }

  tags = {
    Project = var.project
    Env     = var.env
    Service = var.service
  }

  lifecycle {
    create_before_destroy = true
  }
}