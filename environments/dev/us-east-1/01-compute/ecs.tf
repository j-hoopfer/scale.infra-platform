# ── Cluster ────────────────────────────────────────────────────────────────────
resource "aws_ecs_cluster" "main" {
  name = "shared-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  configuration {
    execute_command_configuration {
      logging = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.ecs_exec.name
      }
    }
  }
}

# ── Capacity Providers ─────────────────────────────────────────────────────────
# Managed as a separate resource — aws_ecs_cluster no longer accepts
# capacity_providers inline as of AWS provider v5.
resource "aws_ecs_cluster_capacity_providers" "main" {
  cluster_name = aws_ecs_cluster.main.name

  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 60
    capacity_provider = "FARGATE"
  }

  default_capacity_provider_strategy {
    weight            = 40
    capacity_provider = "FARGATE_SPOT"
  }
}
