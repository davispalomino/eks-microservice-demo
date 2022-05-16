resource "kubernetes_service" "this" {
  metadata {
    name      = var.name
    namespace = var.namespace
    labels = {
      app = var.name
    }
  }

  spec {
    selector = {
      app = var.name
    }
    port {
      port        = var.port
      target_port = var.target_port
      protocol    = var.protocol
    }
  }
}