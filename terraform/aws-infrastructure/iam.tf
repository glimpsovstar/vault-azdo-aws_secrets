# IAM Resources for Vault Integration
# Simplified approach - only create roles, use existing AWS credentials for Vault

# Data source for current AWS account
data "aws_caller_identity" "current" {}

# Note: We'll use existing AWS credentials (from dmcred) for Vault instead of creating a new user
# This avoids IAM user creation permissions issues

# Infrastructure Role - Full permissions for infrastructure provisioning
resource "aws_iam_role" "infrastructure" {
  name = "VaultInfrastructureRole"
  path = "/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = data.aws_caller_identity.current.arn
        }
        Action = "sts:AssumeRole"
      },
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::009930020555:root"  # HCP Vault account with cross-account feature enabled
        }
        Action = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            "aws:PrincipalArn" = "arn:aws:iam::009930020555:role/HCP-Vault-77f00701-09e9-4be5-985d-5890467ce43b-VaultNode"
          }
        }
      }
    ]
  })

  tags = merge(var.common_tags, {
    Name        = "VaultInfrastructureRole"
    Purpose     = "Full infrastructure provisioning via Vault"
  })
}

# Infrastructure Role Policy - Broad permissions
resource "aws_iam_role_policy" "infrastructure" {
  name = "infrastructure-permissions"
  role = aws_iam_role.infrastructure.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:*",
          "vpc:*",
          "iam:ListInstanceProfiles",
          "iam:PassRole"
        ]
        Resource = "*"
      }
    ]
  })
}

# S3-Only Role - Limited permissions for developers
resource "aws_iam_role" "s3_only" {
  name = "VaultS3OnlyRole"
  path = "/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = data.aws_caller_identity.current.arn
        }
        Action = "sts:AssumeRole"
      },
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::009930020555:root"  # HCP Vault account with cross-account feature enabled
        }
        Action = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            "aws:PrincipalArn" = "arn:aws:iam::009930020555:role/HCP-Vault-77f00701-09e9-4be5-985d-5890467ce43b-VaultNode"
          }
        }
      }
    ]
  })

  tags = merge(var.common_tags, {
    Name        = "VaultS3OnlyRole"
    Purpose     = "S3-only access via Vault"
  })
}

# S3-Only Role Policy - Limited permissions
resource "aws_iam_role_policy" "s3_only" {
  name = "s3-only-permissions"
  role = aws_iam_role.s3_only.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:CreateBucket",
          "s3:ListBucket",
          "s3:ListAllMyBuckets",
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:PutBucketPolicy",
          "s3:GetBucketPolicy",
          "s3:GetBucketLocation",
          "s3:DeleteBucket"
        ]
        Resource = "*"
      }
    ]
  })
}