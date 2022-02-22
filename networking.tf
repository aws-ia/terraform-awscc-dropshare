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
resource "aws_acm_certificate_validation" "main" {
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

# see https://registry.terraform.io/providers/hashicorp/awscc/latest/docs/resources/cloudfront_cache_policy
resource "awscc_cloudfront_cache_policy" "main" {
  cache_policy_config = {
    comment     = "Default policy when CF compression is enabled"
    default_ttl = 86400
    max_ttl     = 31536000
    min_ttl     = 1
    name        = "Managed-CachingOptimized"

    # see https://registry.terraform.io/providers/hashicorp/awscc/latest/docs/resources/cloudfront_cache_policy#nested-schema-for-cache_policy_configparameters_in_cache_key_and_forwarded_to_origin
    parameters_in_cache_key_and_forwarded_to_origin = {
      cookies_config = {
        cookie_behavior = "none"
      }

      enable_accept_encoding_brotli = true
      enable_accept_encoding_gzip   = true

      # see https://registry.terraform.io/providers/hashicorp/awscc/latest/docs/resources/cloudfront_cache_policy#nested-schema-for-cache_policy_configparameters_in_cache_key_and_forwarded_to_originheaders_config
      headers_config = {
        header_behavior = "none"
        header          = []
      }

      # see https://registry.terraform.io/providers/hashicorp/awscc/latest/docs/resources/cloudfront_cache_policy#nested-schema-for-cache_policy_configparameters_in_cache_key_and_forwarded_to_originquery_strings_config
      query_strings_config = {
        query_string_behavior = "none"
      }
    }
  }
}

# see https://registry.terraform.io/providers/hashicorp/awscc/latest/docs/resources/cloudfront_distribution
resource "awscc_cloudfront_distribution" "main" {
  distribution_config = {
    aliases = [
      aws_acm_certificate.main.domain_name
    ]

    comment = var.cloudfront_comment

    # see https://registry.terraform.io/providers/hashicorp/awscc/latest/docs/resources/cloudfront_distribution#nestedatt--distribution_config--default_cache_behavior
    default_cache_behavior = {
      allowed_methods = [
        "HEAD",
        "GET",
      ]

      cache_policy_id = awscc_cloudfront_cache_policy.main.id

      cached_methods = [
        "HEAD",
        "GET",
      ]

      compress    = true
      default_ttl = 300
      max_ttl     = 86400
      min_ttl     = 60

      smooth_streaming = false
      target_origin_id = aws_s3_bucket.main.bucket_regional_domain_name
      #      trusted_key_groups
      #      trusted_signers
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
        domain_name         = aws_s3_bucket.main.bucket_regional_domain_name
        id                  = aws_s3_bucket.main.bucket_regional_domain_name

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
      # use `aws_acm_certificate_validation` to avoid race conditions with validation
      acm_certificate_arn      = aws_acm_certificate_validation.main.certificate_arn
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
