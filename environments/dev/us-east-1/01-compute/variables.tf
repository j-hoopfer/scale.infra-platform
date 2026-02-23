variable "domain_name" {
  description = "Apex domain name for ACM certificate and Route 53 hosted zone lookup (e.g. scale-consulting.io). Set per environment in the corresponding .tfvars file."
  type        = string
}
