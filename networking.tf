# see https://registry.terraform.io/providers/hashicorp/awscc/latest/docs/data-sources/route53_hosted_zone
data "awscc_route53_hosted_zone" "main" {
  id = var.routed53_zone_id
}

# see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate
resource "aws_acm_certificate" "main" {
  # ACM Certificates must be in `us-east-1` to be accessible to CloudFront
  provider = aws.certificates

  domain_name       = "${var.route53_record_subdomain}.${trimsuffix(data.awscc_route53_hosted_zone.main.name, ".")}"
  validation_method = "DNS"

  options {
    # see https://docs.aws.amazon.com/acm/latest/userguide/acm-concepts.html#concept-transparency
    certificate_transparency_logging_preference = "ENABLED"
  }

  # see https://www.terraform.io/language/meta-arguments/lifecycle
  lifecycle {
    # it is recommended to allow replacement of in-use certificates
    create_before_destroy = true
  }
}

# see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record
resource "aws_route53_record" "validation" {
  # iterate over available validation methods
  for_each = {
    for options in aws_acm_certificate.main.domain_validation_options : options.domain_name => {
      name   = options.resource_record_name
      record = options.resource_record_value
      type   = options.resource_record_type
    }
  }

  # allow overwriting of original value, in case of re-issuance of a certificate
  allow_overwrite = true
  name            = each.value.name

  records = [
    each.value.record
  ]

  ttl     = 60
  type    = each.value.type
  zone_id = data.awscc_route53_hosted_zone.main.id
}

# see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation
resource "aws_acm_certificate_validation" "validation" {
  # ACM Certificates must be in `us-east-1` to be accessible to CloudFront
  provider = aws.certificates

  certificate_arn = aws_acm_certificate.main.arn

  validation_record_fqdns = [
    for record in aws_route53_record.validation : record.fqdn
  ]
}

# see https://registry.terraform.io/providers/hashicorp/awscc/latest/docs/resources/cloudfront_cloudfront_origin_access_identity
resource "awscc_cloudfront_cloudfront_origin_access_identity" "main" {
  cloudfront_origin_access_identity_config = {
    comment = var.cloudfront_comment
  }
}

## see https://registry.terraform.io/providers/hashicorp/awscc/latest/docs/resources/cloudfront_distribution
resource "awscc_cloudfront_distribution" "main" {
  distribution_config = {
    aliases = [
      aws_acm_certificate.main.domain_name
    ]

    comment = var.cloudfront_comment

    default_cache_behavior = {
      allowed_methods = [
        "HEAD",
        "GET",
      ]

      #cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"

      cached_methods = [
        "HEAD",
        "GET",
      ]

      compress               = true
      smooth_streaming       = false
      target_origin_id       = "operatehappy-dropshare-aws.s3.us-west-1.amazonaws.com"
      viewer_protocol_policy = "https-only"
    }

    default_root_object = basename(var.bucket_index_file)
    enabled             = true
    http_version        = "http2"
    ipv6_enabled        = true

    origins = [
      {
        connection_attempts = 3
        connection_timeout  = 10
        domain_name         = awscc_s3_bucket.main.regional_domain_name
        id                  = awscc_s3_bucket.main.regional_domain_name

        origin_shield = {
          enabled = false
        }

        s3_origin_config = {
          origin_access_identity = "origin-access-identity/cloudfront/${awscc_cloudfront_cloudfront_origin_access_identity.main.id}"
        }
      },
    ]

    origin_groups = {
      quantity = 0
    }

    price_class = "PriceClass_100"

    viewer_certificate = {
      acm_certificate_arn      = aws_acm_certificate.main.id
      minimum_protocol_version = var.cloudfront_minimum_protocol_version
      ssl_support_method       = "sni-only"
    }
  }
}

# see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record
resource "aws_route53_record" "a" {
  zone_id = data.awscc_route53_hosted_zone.main.id
  name    = aws_acm_certificate.main.domain_name
  type    = "A"

  alias {
    name = awscc_cloudfront_distribution.main.domain_name

    # see https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-route53-aliastarget.html#aws-properties-route53-aliastarget-properties
    zone_id                = var.cloudfront_zone_id
    evaluate_target_health = false
  }
}

# see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record
resource "aws_route53_record" "aaaa" {
  zone_id = data.awscc_route53_hosted_zone.main.id
  name    = aws_acm_certificate.main.domain_name
  type    = "AAAA"

  alias {
    name = awscc_cloudfront_distribution.main.domain_name

    # see https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-route53-aliastarget.html#aws-properties-route53-aliastarget-properties
    zone_id                = var.cloudfront_zone_id
    evaluate_target_health = false
  }
}
