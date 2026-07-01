resource "aws_acm_certificate" "it_tools_acm_cert" {
  domain_name               = var.it_tools_domain_name_root
  validation_method         = "DNS"
  subject_alternative_names = [var.it_tools_domain_name_www]

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_route53_zone" "it_tools_public_hosted_zone" {
  name         = var.it_tools_domain_name_root
  private_zone = false
}

resource "aws_route53_record" "it_tools_validation_records" {
  for_each = {
    for dvo in aws_acm_certificate.it_tools_acm_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  name    = each.value.name
  records = [each.value.record]
  ttl     = 60
  type    = each.value.type
  zone_id = data.aws_route53_zone.it_tools_public_hosted_zone.zone_id
}

resource "aws_acm_certificate_validation" "it_tools_acm_cert_validation" {
  certificate_arn         = aws_acm_certificate.it_tools_acm_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.it_tools_validation_records : record.fqdn]
}

resource "aws_route53_record" "root" {
  zone_id = data.aws_route53_zone.it_tools_public_hosted_zone.zone_id
  name    = var.it_tools_domain_name_root
  type    = "A"

  alias {
    name                   = var.it_tools_alb_dns_name
    zone_id                = var.it_tools_alb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.it_tools_public_hosted_zone.zone_id
  name    = var.it_tools_domain_name_www
  type    = "A"

  alias {
    name                   = var.it_tools_alb_dns_name
    zone_id                = var.it_tools_alb_zone_id
    evaluate_target_health = true
  }
}