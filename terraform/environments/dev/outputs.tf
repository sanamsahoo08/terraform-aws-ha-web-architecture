output "dev_vpc_id" {
  description = "VPC ID for development"
  value       = module.vpc.vpc_id
}

output "dev_public_subnets" {
  description = "Public subnets list"
  value       = module.vpc.public_subnet_ids
}
