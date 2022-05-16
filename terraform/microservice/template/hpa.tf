module "horizontal-pod-autoscaler" {
  source = "./modules/hpa"

  name                       = var.template_name == null ? random_string.this.result : var.template_name
  max_replicas               = var.max_replicas
  min_replicas               = var.min_replicas
  average_utilization_cpu    = var.average_utilization_cpu
  average_utilization_memory = var.average_utilization_memory
}