# Fargate Migration Infrastructure

Infrastructure-as-code for EC2 to ECS Fargate migration project.

## Repository Structure

This repository uses a **Layered State** approach to separate Networking from Applications.

- `terraform/bootstrap/` - One-time S3 + DynamoDB setup for Terraform state
- `terraform/modules/` - Reusable Terraform modules
- `terraform/environments/` - Environment configs
    - `00-network`: Network foundation (VPCs, subnets, routing)
    - `10-application`: Application resources (EC2, ECS, RDS, ALB)

## Prerequisites

- AWS CLI v2 with SSO configured
- Terraform 1.7.0+ (managed via tfenv)
- Docker

## Getting Started

### For Brownfield Migration (Existing Infrastructure):

1. **Bootstrap**: `cd terraform/bootstrap && terraform apply`
2. **Import Network**: Navigate to `environments/dev/00-network`, write Terraform code, import resources
3. **Import Apps**: Navigate to `environments/dev/10-application`, write Terraform code, import resources
4. **Verify**: Run `terraform plan` - should show zero changes
5. **Add Fargate**: Create new ECS resources in `10-application`

See [Migration Appendix](../docs/ecs-migration-plan-appendix.md#11-enterprise-terraform-organization--repository-structure) for detailed guidance.

## Team Access

- AWS SSO Portal: https://d-abc123xyz.awsapps.com/start
- Profile: `fargate-migration`
- Login: `aws sso login --profile fargate-migration`
