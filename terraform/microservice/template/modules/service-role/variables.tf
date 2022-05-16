variable "template_name" {
  description = "Nombre asignado a todos los recursos creados por esta plantilla."
  type        = string
  default     = null
}

variable "service" {
  description = "Nombre asignado a todos los recursos creados por esta plantilla."
  type        = string
}

variable "policy" {
  description = "The path of the policy in IAM (tpl file)"
  type        = string
  default     = ""
}

variable "path" {
  description = "Path of IAM role"
  type        = string
  default     = "/"
}

variable "role_permissions_boundary_arn" {
  description = "Permissions boundary ARN to use for IAM role"
  type        = string
  default     = ""
}

variable "max_session_duration" {
  description = "Maximum CLI/API session duration in seconds between 3600 and 43200"
  type        = number
  default     = 3600
}

variable "namespace" {
  default = "default"
  type    = string
}

variable "xray" {
  default = false
}