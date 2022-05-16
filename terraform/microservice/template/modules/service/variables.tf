variable "name" {
  description = "Nombre del deployment"
  type        = string
}

variable "port" {
  description = "Puerto del servicio"
  type        = number
}

variable "target_port" {
  description = "Puerto del pod"
  type        = number
}

variable "protocol" {
  description = "Protocolo del puerto del servicio"
  type        = string
  default     = "TCP"
}

variable "namespace" {
  description = "Nombre de espacio para el pod"
  type        = string
  default     = "default"
}