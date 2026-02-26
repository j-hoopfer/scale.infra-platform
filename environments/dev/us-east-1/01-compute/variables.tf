variable "domain_name" {
  description = "Apex domain name for ACM certificate and Route 53 hosted zone lookup (e.g. scale-consulting.io). Set per environment in the corresponding .tfvars file."
  type        = string
}

variable "dns_account_role_arn" {
  description = "ARN of the terraform-route53-dns-writer role in the DNS account (created in Activity 2 Story 2.4). Required for the aws.dns provider alias. Leave empty if the hosted zone is in the same account."
  type        = string
}
