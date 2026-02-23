# ── Remote State ───────────────────────────────────────────────────────────────
# Reads outputs published by the 00-network stack (VPC ID, subnet IDs, etc.).
# Add additional data sources below as new consumers are introduced.
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "scale-solutions-terraform-state-dev"
    key    = "platform/dev/us-east-1/00-network/terraform.tfstate"
    region = "us-east-1"
  }
}
