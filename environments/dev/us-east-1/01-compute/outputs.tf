# ── Public ALB ─────────────────────────────────────────────────────────────────
output "https_listener_arn" {
  description = "ARN of the public HTTPS listener — service stacks attach listener rules here"
  value       = aws_lb_listener.https.arn
}

output "alb_dns_name" {
  description = "DNS name of the public ALB — used for Route 53 alias records per service"
  value       = aws_lb.public.dns_name
}

output "alb_zone_id" {
  description = "Hosted zone ID of the public ALB — required alongside dns_name for Route 53 alias records"
  value       = aws_lb.public.zone_id
}

output "alb_security_group_id" {
  description = "Security group ID of the public ALB — task SGs must allow inbound from this SG only"
  value       = aws_security_group.alb_public.id
}

# ── Internal ALB ───────────────────────────────────────────────────────────────
output "internal_http_listener_arn" {
  description = "ARN of the internal HTTP listener — used for strangler fig weighted target group rules"
  value       = aws_lb_listener.internal_http.arn
}

output "internal_alb_dns_name" {
  description = "DNS name of the internal ALB — used for service-to-service Route 53 alias records"
  value       = aws_lb.internal.dns_name
}

output "internal_alb_zone_id" {
  description = "Hosted zone ID of the internal ALB — required for Route 53 alias records"
  value       = aws_lb.internal.zone_id
}

output "internal_alb_security_group_id" {
  description = "Security group ID of the internal ALB — task SGs allow inbound from this SG for internal traffic"
  value       = aws_security_group.alb_internal.id
}

# ── ECS Cluster ────────────────────────────────────────────────────────────────
output "ecs_cluster_arn" {
  description = "ARN of the shared ECS cluster — referenced in aws_ecs_service resources"
  value       = aws_ecs_cluster.main.arn
}

output "ecs_cluster_name" {
  description = "Name of the shared ECS cluster — used in CloudWatch dashboards and CLI targeting"
  value       = aws_ecs_cluster.main.name
}

# ── CloudWatch ─────────────────────────────────────────────────────────────────
output "ecs_log_group_name" {
  description = "CloudWatch log group name — set as awslogs-group in each task definition log configuration"
  value       = aws_cloudwatch_log_group.ecs.name
}

# ── Private DNS ────────────────────────────────────────────────────────────────
output "private_zone_id" {
  description = "Route 53 private hosted zone ID — service stack that registers the internal alias records here"
  value       = aws_route53_zone.internal.zone_id
}
