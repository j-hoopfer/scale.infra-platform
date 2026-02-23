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
    role_arn = "arn:aws:iam::945369245148:role/terraform-route53-dns-writer-role"
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
