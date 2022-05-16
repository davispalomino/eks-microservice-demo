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

variable "aws_services" {
  description = "aws services"
  type        = list(string)
}