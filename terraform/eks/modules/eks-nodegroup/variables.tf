variable "cluster_name" {
  description = "cluster name"
  type        = string
}

variable "node_group_name" {
  description = "node group name"
  type        = string
  default     = "default"
}

variable "node_role_arn" {
  description = "node role arn"
  type        = string
}


variable "subnet_ids" {
  description = "subnet ids"
  type        = list(string)
}

variable "desired_size" {
  description = "desired size"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "max size"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "min size"
  type        = number
  default     = 1
}

variable "ami_type" {
  description = "ami type"
  type        = string
  default     = "AL2_x86_64"
}

variable "capacity_type" {
  description = "capacity type"
  type        = string
  default     = "SPOT"
}

variable "disk_size" {
  description = "disk size"
  type        = number
  default     = 20
}

variable "instance_types" {
  description = "instance types"
  type        = list(string)
  default     = ["t3.medium", "t3a.medium"]
}

variable "tags" {
  description = "tags"
  type        = map(string)
  default     = {}
}

variable "force_update_version" {
  description = "force update version"
  type        = bool
  default     = false
}

variable "launch_template_version" {
  description = "launch template version"
  type        = string
}

variable "launch_template_id" {
  description = "launch template id"
  type        = string
}