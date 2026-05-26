variable "bucket_id" {
  description = "ID (name) of the S3 bucket to configure CORS for"
  type        = string
}

variable "cors_rules" {
  description = "List of CORS rule configurations"
  type = list(object({
    id              = optional(string, null)
    allowed_headers = optional(list(string), ["*"])
    allowed_methods = list(string)
    allowed_origins = list(string)
    expose_headers  = optional(list(string), [])
    max_age_seconds = optional(number, 3600)
  }))
  default = [{
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    allowed_headers = ["*"]
    expose_headers  = []
    max_age_seconds = 3600
  }]
}
