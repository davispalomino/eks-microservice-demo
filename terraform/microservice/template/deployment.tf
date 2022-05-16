module "deployment" {
  source = "./modules/deployment"

  name                  = var.template_name == null ? random_string.this.result : var.template_name
  namespace             = var.namespace
  container_port        = var.container_port
  replicas              = var.replicas
  protocol              = var.protocol
  memory                = var.memory
  cpu                   = var.cpu
  environment           = var.env
  environment_secret    = var.env_secret
  image                 = var.image
  liveness_probe_path   = var.liveness_probe_path
  initial_delay_seconds = var.initial_delay_seconds
  period_seconds        = var.period_seconds
  role_pod              = var.pod_role
}