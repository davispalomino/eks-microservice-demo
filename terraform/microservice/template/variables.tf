variable "template_name" {
  description = "Nombre asignado a todos los recursos creados por esta plantilla."
  type        = string
  default     = null
}

variable "namespace" {
  description = "Nombre de espacio para los recursos creados"
  type        = string
  default     = "default"
}

variable "container_port" {
  description = "Puerto del pod"
  type        = number
}

variable "port" {
  description = "Puerto del service"
  type        = number
  default     = 80
}

variable "replicas" {
  description = "Numero de replicas"
  type        = number
  default     = 2
}

variable "protocol" {
  description = "Protocolo del puerto del pod"
  type        = string
  default     = "TCP"
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

variable "env" {
  description = "Variables de entorno"
  type        = map(string)
  default     = null
}

variable "env_secret" {
  description = "Variables de entorno secretos"
  type        = any
  default     = null
}

variable "image" {
  description = "URI de imagen"
  type        = string
}

variable "image_pull_secrets" {
  description = "Secreto para el acceso al registro de contenedores"
  type        = string
  default     = null
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

variable "max_replicas" {
  description = "Maximo de replicas"
  type        = number
}

variable "min_replicas" {
  description = "Minimo de replicas"
  type        = number
}

variable "average_utilization_cpu" {
  description = "Uso promedio de CPU para activar el escalado"
  type        = number
  default     = 90
}

variable "average_utilization_memory" {
  description = "Uso promedio de MEMORY para activar el escalado"
  type        = number
  default     = 90
}

variable "pod_role" {
  description = "Permisos del POD por rol"
  default     = false
}