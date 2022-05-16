variable "project" {
  type = string
}

variable "service" {
  type = string
}

variable "env" {
  type = string
}

variable "image_tag_mutability" {
  description = "The image tag mutability"
  type        = string
  default     = "MUTABLE"
}

variable "kms_key" {
  description = "The kms key"
  type        = string
  default     = null
}

variable "scan_on_push" {
  description = "The scan on push"
  type        = bool
  default     = true
}
