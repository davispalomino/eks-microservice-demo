module "service" {
  source = "./modules/service"

  name        = var.template_name == null ? random_string.this.result : var.template_name
  namespace   = var.namespace
  port        = var.port
  target_port = var.container_port
  protocol    = var.protocol
}