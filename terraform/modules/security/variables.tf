variable "environment" {
  description = "Deployment environment name"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID where security groups will be created"
  type        = string
}

variable "app_port" {
  description = "Application port exposed to the ALB"
  type        = number
  default     = 80
}
