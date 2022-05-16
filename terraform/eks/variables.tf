variable "project" {
  description = "project name"
  type        = string
}

variable "service" {
  description = "service name"
  type        = string
}

variable "env" {
  description = "environment name"
  type        = string
}

variable "endpoint_private_access" {
  description = "endpoint private access"
  type        = bool
  default     = false
}

variable "endpoint_public_access" {
  description = "endpoint public access"
  type        = bool
  default     = true
}

variable "desired_size" {
  description = "desired size"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "min size"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "max size"
  type        = number
  default     = 2
}

variable "disk_size" {
  description = "disk size"
  type        = number
  default     = 20
}

variable "instance_types" {
  description = "instance type"
  type        = list(string)
  default     = ["t3.medium", "t3a.medium"]
}

variable "eks_version" {
  description = "eks version"
  type        = string
  default     = "1.19"
}

variable "policy_arn" {
  description = "policies for the cluster"
  type        = list(string)
  default = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AutoScalingFullAccess",
    "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM",
    "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  ]
}

variable "capacity_type" {
  description = "capacity type"
  type        = string
  default     = "SPOT"
}