# Outputs for AWS Infrastructure
# These outputs can be used by other Terraform configurations or for reference

# VPC Information
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

# Subnet Information
output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = aws_subnet.private[*].id
}

# Security Group Information
output "demo_security_group_id" {
  description = "ID of the demo security group"
  value       = aws_security_group.demo.id
}

output "vault_agent_security_group_id" {
  description = "ID of the vault agent security group"
  value       = aws_security_group.vault_agent.id
}

# IAM Role Information for Vault
output "current_aws_identity" {
  description = "Current AWS identity that can assume roles"
  value       = data.aws_caller_identity.current.arn
}

output "infrastructure_role_arn" {
  description = "ARN of the infrastructure role"
  value       = aws_iam_role.infrastructure.arn
}

output "s3_only_role_arn" {
  description = "ARN of the S3-only role"
  value       = aws_iam_role.s3_only.arn
}

output "aws_account_id" {
  description = "AWS Account ID"
  value       = data.aws_caller_identity.current.account_id
}

# Configuration for Vault AWS Secrets Engine
output "vault_aws_config" {
  description = "Configuration values for Vault AWS secrets engine"
  value = {
    # Note: Use existing AWS credentials from dmcred instead of these
    current_identity_arn    = data.aws_caller_identity.current.arn
    region                  = var.aws_region
    infrastructure_role_arn = aws_iam_role.infrastructure.arn
    s3_only_role_arn       = aws_iam_role.s3_only.arn
  }
}