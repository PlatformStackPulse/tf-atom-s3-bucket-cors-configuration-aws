output "enabled" {
  description = "Whether the module is enabled."
  value       = local.enabled
}

output "id" {
  description = "ID of the CORS configuration"
  value       = try(aws_s3_bucket_cors_configuration.this[0].id, null)
}
