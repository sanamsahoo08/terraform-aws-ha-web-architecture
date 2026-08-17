output "dev_vpc_id" {
  description = "VPC ID for development"
  value       = module.vpc.vpc_id
}

output "dev_public_subnets" {
  description = "Public subnets list"
  value       = module.vpc.public_subnet_ids
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "alb_endpoint" {
  description = "Public HTTP endpoint to access the application"
  value       = "http://${module.compute.alb_dns_name}"
}
