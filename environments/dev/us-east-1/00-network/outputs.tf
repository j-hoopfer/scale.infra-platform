# Outputs for application layer to consume
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.existing.id
}

output "public_subnet_ids" {
  description = "IDs of public subnets (for ALB)"
  value       = [aws_subnet.public_1a.id, aws_subnet.public_1b.id]
}

output "private_subnet_ids" {
  description = "IDs of private subnets (for ECS tasks)"
  value       = [aws_subnet.private_1a.id, aws_subnet.private_1b.id]
}
