# ── Application Logs ───────────────────────────────────────────────────────────
# Consumed by task definitions via the awslogs driver.
resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/shared"
  retention_in_days = 30
}

# ── ECS Exec Audit Logs ────────────────────────────────────────────────────────
# Records which IAM principal ran which command in which container via ECS Exec.
resource "aws_cloudwatch_log_group" "ecs_exec" {
  name              = "/ecs/exec"
  retention_in_days = 30
}
