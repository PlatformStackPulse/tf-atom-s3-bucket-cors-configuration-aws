# -----------------------------------------------------------------------------
# Unit tests — tf-atom-s3-bucket-cors-configuration-aws
#
# Provider is mocked, so we only assert on plan-KNOWN values:
#   - module enablement (output.enabled)
#   - resource count (length of the count-gated resource)
#   - input pass-throughs into the dynamic cors_rule block
# We do NOT assert on the computed `id` output — it is unknown under a mock
# provider at plan time and asserting on it would error.
# -----------------------------------------------------------------------------

mock_provider "aws" {}

variables {
  namespace   = "eg"
  stage       = "test"
  name        = "thing"
  environment = "ue1"

  bucket_id = "eg-test-thing-bucket"
}

# When enabled (default), exactly one CORS configuration is planned and the
# resource receives the bucket + rules we passed in.
run "creates_when_enabled" {
  command = plan

  assert {
    condition     = output.enabled == true
    error_message = "enabled output should be true by default"
  }

  assert {
    condition     = length(aws_s3_bucket_cors_configuration.this) == 1
    error_message = "Exactly one CORS configuration should be planned when enabled"
  }

  assert {
    condition     = aws_s3_bucket_cors_configuration.this[0].bucket == "eg-test-thing-bucket"
    error_message = "CORS configuration should target the provided bucket_id"
  }
}

# Custom rules must flow through the dynamic cors_rule block unchanged.
run "applies_custom_cors_rules" {
  command = plan

  variables {
    cors_rules = [{
      allowed_methods = ["GET", "PUT", "POST"]
      allowed_origins = ["https://example.com"]
      allowed_headers = ["Authorization", "Content-Type"]
      expose_headers  = ["ETag"]
      max_age_seconds = 7200
    }]
  }

  # cors_rule is a set of objects (unaddressable by index); assert on its
  # size and use a for-expression to reach into the single planned rule.
  assert {
    condition     = length(aws_s3_bucket_cors_configuration.this[0].cors_rule) == 1
    error_message = "One cors_rule should be planned"
  }

  assert {
    condition = anytrue([
      for r in aws_s3_bucket_cors_configuration.this[0].cors_rule :
      toset(r.allowed_methods) == toset(["GET", "PUT", "POST"])
    ])
    error_message = "allowed_methods should pass through unchanged"
  }

  assert {
    condition = anytrue([
      for r in aws_s3_bucket_cors_configuration.this[0].cors_rule :
      r.max_age_seconds == 7200
    ])
    error_message = "max_age_seconds should pass through unchanged"
  }
}

# When disabled, nothing is created and the id output is null.
run "disabled_creates_nothing" {
  command = plan

  variables {
    enabled = false
  }

  assert {
    condition     = length(aws_s3_bucket_cors_configuration.this) == 0
    error_message = "No CORS configuration should be planned when disabled"
  }

  assert {
    condition     = output.id == null
    error_message = "id output should be null when disabled"
  }

  assert {
    condition     = output.enabled == false
    error_message = "enabled output should be false when disabled"
  }
}
