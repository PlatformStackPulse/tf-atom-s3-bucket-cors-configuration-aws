# tf-atom-s3-bucket-cors-configuration-aws

[![CI](https://github.com/PlatformStackPulse/tf-atom-s3-bucket-cors-configuration-aws/actions/workflows/ci.yml/badge.svg)](https://github.com/PlatformStackPulse/tf-atom-s3-bucket-cors-configuration-aws/actions/workflows/ci.yml)
[![Release](https://github.com/PlatformStackPulse/tf-atom-s3-bucket-cors-configuration-aws/actions/workflows/auto-release.yml/badge.svg)](https://github.com/PlatformStackPulse/tf-atom-s3-bucket-cors-configuration-aws/actions/workflows/auto-release.yml)

---

## Purpose

Configures Cross-Origin Resource Sharing (CORS) rules for an S3 bucket. Allows web browsers to make cross-origin requests to S3 objects. Supports multiple rules with customizable methods, origins, and headers.

## Architecture

```
┌─────────────────────────────────────────────────────┐
│           Molecule Layer                            │
│  ┌──────────────┐    ┌──────────────────────┐      │
│  │ s3-bucket    │───▶│ THIS MODULE          │      │
│  │ (bucket_id)  │    │ cors-configuration   │      │
│  └──────────────┘    │ (CORS rules)         │      │
│                      └──────────────────────┘      │
└─────────────────────────────────────────────────────┘
```

## Scope

| In Scope | Out of Scope |
|----------|--------------|
| `aws_s3_bucket_cors_configuration` resource | Bucket creation (→ `tf-atom-s3-bucket-aws`) |
| Multiple CORS rules via dynamic block | CloudFront CORS headers |
| Allowed methods, origins, headers | Bucket policy for cross-account |
| Expose headers and max age | Website configuration (→ `tf-atom-s3-bucket-website-configuration-aws`) |

## Features

- **Single-resource atom** — one `aws_s3_bucket_cors_configuration`
- **Multiple rules** — supports any number of CORS rules via list
- **Sensible defaults** — GET from all origins with all headers
- **Dynamic block** — clean HCL with `for_each`
- **Tested** — unit tests for defaults, disabled, and custom rules

## Usage

```hcl
module "bucket_cors" {
  source = "github.com/PlatformStackPulse/tf-atom-s3-bucket-cors-configuration-aws?ref=v1.0.0"

  context   = module.this.context
  bucket_id = module.bucket.bucket_id

  cors_rules = [{
    allowed_methods = ["GET", "PUT"]
    allowed_origins = ["https://myapp.com"]
    allowed_headers = ["*"]
    max_age_seconds = 3600
  }]
}
```

## Module Documentation

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
