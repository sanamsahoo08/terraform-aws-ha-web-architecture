output "alb_security_group_id" {
  description = "Security Group ID of the Application Load Balancer"
  value       = aws_security_group.alb.id
}

output "app_security_group_id" {
  description = "Security Group ID of the Compute/App instances"
  value       = aws_security_group.app.id
}

output "instance_profile_name" {
  description = "IAM Instance Profile Name for compute workloads"
  value       = aws_iam_instance_profile.app_profile.name
}

output "iam_role_arn" {
  description = "IAM Role ARN attached to compute workloads"
  value       = aws_iam_role.app_instance_role.arn
}
