# -----------------------------------------------------
# Atom: S3 Bucket CORS Configuration
# Configures Cross-Origin Resource Sharing rules.
# -----------------------------------------------------
resource "aws_s3_bucket_cors_configuration" "this" {
  count = module.this.enabled ? 1 : 0

  bucket = var.bucket_id

  dynamic "cors_rule" {
    for_each = var.cors_rules
    content {
      allowed_headers = cors_rule.value.allowed_headers
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.value.allowed_origins
      expose_headers  = cors_rule.value.expose_headers
      max_age_seconds = cors_rule.value.max_age_seconds
      id              = cors_rule.value.id
    }
  }
}
