variable "name" {
  description = "Nombre del deployment"
  type        = string
}

variable "max_replicas" {
  description = "Maximo de replicas"
  type        = number
}

variable "min_replicas" {
  description = "Minimo de replicas"
  type        = number
}

variable "kind" {
  description = "Tipo de referencia"
  type        = string
  default     = "Deployment"
}

variable "api_version" {
  description = "Version de API"
  type        = string
  default     = "apps/v1"
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