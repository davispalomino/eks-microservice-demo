variable "project" {
  description = "project name"
  type        = string
}

variable "env" {
  description = "environment name"
  type        = string
}

variable "service" {
  description = "service name"
  type        = string
}

variable "timeout_create" {
  description = "timeout create"
  type        = string
  default     = "60m"
}

variable "timeout_delete" {
  description = "timeout delete"
  type        = string
  default     = "60m"
}

variable "timeout_update" {
  description = "timeout update"
  type        = string
  default     = "60m"
}

variable "role_arn" {
  description = "role arn"
  type        = string
}

variable "eks_version" {
  description = "eks version"
  type        = string
  default     = "1.18"
}

variable "enabled_cluster_log_types" {
  description = "enabled cluster log types"
  type        = list(string)
  default     = ["api", "audit"]
}

variable "endpoint_private_access" {
  description = "endpoint private access"
  type        = bool
  default     = true
}

variable "endpoint_public_access" {
  description = "endpoint public access"
  type        = bool
  default     = false
}

variable "subnet_ids" {
  description = "subnet ids"
  type        = list(string)
}

variable "security_group_ids" {
  description = "security group ids"
  type        = list(string)
  default     = []
}

variable "encryption_config" {
  description = "encryption config"
  type = list(object({
    key_arn   = string
    resources = list(string)
  }))
  default = []
}