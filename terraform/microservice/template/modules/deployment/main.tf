resource "kubernetes_deployment" "this" {
  metadata {
    name      = var.name
    namespace = var.namespace
    labels = {
      app = var.name
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = var.name
      }
    }

    template {
      metadata {
        labels = {
          app = var.name
        }
      }

      spec {
        service_account_name            = var.role_pod == false ? null : var.name
        automount_service_account_token = var.role_pod == false ? null : true

        container {
          image = var.image
          name  = var.name

          dynamic "env" {
            for_each = var.environment == null ? {} : var.environment
            content {
              name  = env.key
              value = env.value
            }
          }

          dynamic "env" {
            for_each = var.environment_secret == null ? {} : var.environment_secret
            content {
              name = env.key
              value_from {
                secret_key_ref {
                  name = env.value["secret_name"]
                  key  = env.value["secret_key"]
                }
              }
            }
          }

          dynamic "resources" {
            for_each = var.memory == null ? [] : [1]
            content {
              limits = {
                cpu    = var.cpu
                memory = var.memory
              }
              requests = {
                cpu    = var.cpu
                memory = var.memory
              }
            }
          }

          dynamic "port" {
            for_each = var.container_port == null ? [] : [1]
            content {
              container_port = var.container_port
              protocol       = var.protocol
            }
          }

          dynamic "liveness_probe" {
            for_each = var.liveness_probe_path == null ? [] : [1]
            content {
              http_get {
                path = var.liveness_probe_path
                port = var.container_port
              }
              initial_delay_seconds = var.initial_delay_seconds
              period_seconds        = var.period_seconds
            }
          }
        }

        dynamic "image_pull_secrets" {
          for_each = var.image_pull_secrets == null ? [] : [1]
          content {
            name = var.image_pull_secrets
          }
        }
      }
    }
  }
}