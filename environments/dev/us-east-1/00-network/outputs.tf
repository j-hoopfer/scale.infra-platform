# Outputs for application layer to consume
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.existing.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC — consumed by downstream stacks (e.g. internal ALB security group) to avoid hardcoding the CIDR and ensure it stays in sync with the network layer"
  value       = aws_vpc.existing.cidr_block
}

output "public_subnet_ids" {
  description = "IDs of public subnets (for ALB)"
  value       = [aws_subnet.public_1a.id, aws_subnet.public_1b.id]
}

output "private_subnet_ids" {
  description = "IDs of private subnets (for ECS tasks)"
  value       = [aws_subnet.private_1a.id, aws_subnet.private_1b.id]
}
