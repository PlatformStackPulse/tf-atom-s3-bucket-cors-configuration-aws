provider "aws" {
  region = "eu-west-2"
}

module "s3_cors" {
  source = "../../"

  namespace   = "psp"
  environment = "dev"
  name        = "assets"

  bucket_id = "psp-dev-assets"

  cors_rules = [{
    allowed_methods = ["GET", "PUT"]
    allowed_origins = ["https://app.example.com"]
    allowed_headers = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3600
  }]
}

output "id" {
  value = module.s3_cors.id
}
