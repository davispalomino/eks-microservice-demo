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

variable "vpc_id" {
  description = "vpc id"
  type        = string
}

variable "description" {
  description = "vpc description"
  type        = string
  default     = "virtual firewall that controls the traffic"
}