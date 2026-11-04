data "aws_caller_identity" "current" {}

output "aws_account_id" {
  description = "AWS Account Id used by this configuration"
  value       = data.aws_caller_identity.current.account_id
}

output "aws_identity_arn" {
  description = "AWS Identity used by this configuration"
  value       = data.aws_caller_identity.current.arn
}