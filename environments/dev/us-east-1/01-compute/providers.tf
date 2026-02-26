provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Environment = "dev"
      Repository  = "infra-platform"
      ManagedBy   = "Terraform"
      Owner       = "PlatformTeam"
    }
  }
}

provider "aws" {
  alias  = "dns"
  region = "us-east-1"

  assume_role {
    role_arn = var.dns_account_role_arn
  }

  default_tags {
    tags = {
      Environment = "dev"
      Repository  = "infra-platform"
      ManagedBy   = "Terraform"
      Owner       = "PlatformTeam"
    }
  }
}
