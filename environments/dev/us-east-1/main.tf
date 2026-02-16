terraform {
  backend "s3" {
    bucket         = "scale-solutions-terraform-state-dev"
    key            = "platform/dev/us-east-1/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks-dev"
  }
}
