mock_provider "aws" {}

run "creates_cors_with_defaults" {
  variables {
    name        = "test"
    environment = "dev"
    namespace   = "unit"
    bucket_id   = "my-test-bucket"
  }

  assert {
    condition     = output.id != null
    error_message = "id output should not be null when enabled"
  }
}

run "creates_nothing_when_disabled" {
  variables {
    name        = "test"
    environment = "dev"
    namespace   = "unit"
    enabled     = false
    bucket_id   = "my-test-bucket"
  }

  assert {
    condition     = length(aws_s3_bucket_cors_configuration.this) == 0
    error_message = "No resource should be created when disabled"
  }
}

run "supports_custom_cors_rules" {
  variables {
    name        = "test"
    environment = "dev"
    namespace   = "unit"
    bucket_id   = "my-test-bucket"
    cors_rules = [{
      allowed_methods = ["GET", "PUT", "POST"]
      allowed_origins = ["https://example.com"]
      allowed_headers = ["Authorization", "Content-Type"]
      expose_headers  = ["ETag"]
      max_age_seconds = 7200
    }]
  }

  assert {
    condition     = output.id != null
    error_message = "Should create CORS config with custom rules"
  }
}
