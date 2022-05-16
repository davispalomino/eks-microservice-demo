module "k8s-service" {
  source = "./template"

  template_name         = "${var.project}-${var.env}-${var.service}"
  image                 = var.image
  liveness_probe_path   = var.health
  initial_delay_seconds = 30
  period_seconds        = 10
  container_port        = var.port
  port                  = 80
  pod_role              = true
  cpu                   = "100m"
  memory                = "256Mi"
  replicas              = 2
  min_replicas          = 2
  max_replicas          = 2
}