variable "name" {
  description = "Nombre del deployment"
  type        = string
}

variable "replicas" {
  description = "Numero de replicas"
  type        = number
  default     = 1
}

variable "namespace" {
  description = "Nombre de espacio para el pod"
  type        = string
  default     = "default"
}

variable "role_pod" {
  description = "Iam role asignado al pod"
  default     = false
}

variable "image" {
  description = "URI de imagen"
  type        = string
}

variable "environment" {
  description = "Variables de entorno"
  type        = map(string)
  default     = null
}

variable "environment_secret" {
  description = "Variables de entorno secretos"
  type        = any
  default     = null
}

variable "memory" {
  description = "Limite de memoria"
  type        = string
  default     = null
}

variable "cpu" {
  description = "Limite de cpu"
  type        = string
  default     = null
}

variable "container_port" {
  description = "Puerto del pod"
  type        = number
  default     = null
}

variable "protocol" {
  description = "Protocolo del puerto del pod"
  type        = string
  default     = "TCP"
}

variable "liveness_probe_path" {
  description = "Ruta de la sonda de prueba"
  type        = string
  default     = null
}

variable "initial_delay_seconds" {
  description = "Segundos de retrazo para el inicio de la sonda de prueba"
  type        = number
  default     = 3
}

variable "period_seconds" {
  description = "Periodo en segundos para la sonda de prueba"
  type        = number
  default     = 10
}

variable "image_pull_secrets" {
  description = "Secreto para el acceso al registro de contenedores"
  type        = string
  default     = null
}