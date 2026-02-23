# ── Private DNS (Service Discovery) ───────────────────────────────────────────
# Internal services resolve each other by name (e.g. auth.services.internal)
# instead of hardcoded ALB DNS names. Traffic never leaves the VPC.
resource "aws_route53_zone" "internal" {
  name = "services.internal"
  vpc {
    vpc_id = data.terraform_remote_state.network.outputs.vpc_id
  }
  comment = "Private hosted zone for service discovery"
}
