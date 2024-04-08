output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.rails_instance.public_ip
}

output "aws_account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "ror_key_secret_arn" {
  description = "The ARN of the ROR key secret in AWS Secrets Manager."
  value       = aws_secretsmanager_secret.ror_key_secret.arn
}

output "ror_key_secret_name" {
  description = "The name of the ROR key secret in AWS Secrets Manager."
  value       = aws_secretsmanager_secret.ror_key_secret.name
}
