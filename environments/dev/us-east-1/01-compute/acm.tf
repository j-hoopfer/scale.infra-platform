# ── Certificate ───────────────────────────────────────────────────────────────
resource "aws_acm_certificate" "main" {
  domain_name               = "*.${var.domain_name}"
  subject_alternative_names = [var.domain_name]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true # Required for safe cert rotation later
  }
}

# ── Validation DNS Records ─────────────────────────────────────────────────────
# Look up the public hosted zone so we can write the CNAME records ACM requires
# to prove domain ownership. This must use the dns provider alias because the
# hosted zone lives in the DNS account, not the workload account.
data "aws_route53_zone" "public" {
  provider = aws.dns

  name         = var.domain_name
  private_zone = false
}

resource "aws_route53_record" "cert_validation" {
  provider = aws.dns

  for_each = {
    for dvo in aws_acm_certificate.main.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  allow_overwrite = true
  zone_id         = data.aws_route53_zone.public.zone_id
  name            = each.value.name
  type            = each.value.type
  records         = [each.value.record]
  ttl             = 60
}

# ── Validation Waiter ──────────────────────────────────────────────────────────
# Blocks apply until ACM confirms the cert is ISSUED before the HTTPS listener
# is created. Without this, the listener may be created against a PENDING cert.
resource "aws_acm_certificate_validation" "main" {
  certificate_arn         = aws_acm_certificate.main.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}
