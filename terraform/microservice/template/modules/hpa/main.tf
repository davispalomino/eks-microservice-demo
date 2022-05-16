resource "kubernetes_horizontal_pod_autoscaler" "this" {
  metadata {
    name = var.name
  }

  spec {
    max_replicas = var.max_replicas
    min_replicas = var.min_replicas

    scale_target_ref {
      kind        = var.kind
      name        = var.name
      api_version = var.api_version
    }

    metric {
      type = "Resource"
      resource {
        name = "memory"
        target {
          type                = "Utilization"
          average_utilization = var.average_utilization_memory
        }
      }
    }

    metric {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type                = "Utilization"
          average_utilization = var.average_utilization_cpu
        }
      }
    }
  }
}