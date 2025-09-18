# AWS Infrastructure Variables (following demo_aws_ec2_app patterns)

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "ap-southeast-2"  # Matching vault-pki-demo
}

variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "demo"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "vault-azdo-demo"
}

# Network Configuration
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.20.0/24"]
}

# EC2 Configuration
variable "ec2_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ec2_ami_id" {
  description = "AMI ID for EC2 instances (default: Amazon Linux 2023)"
  type        = string
  default     = ""  # Will use data source if empty
}

variable "key_pair_name" {
  description = "AWS key pair name for EC2 access"
  type        = string
  default     = "djoo-demo-ec2-keypair"  # Matching vault-pki-demo
}

# Security Group Rules (demo_aws_ec2_app pattern)
variable "security_group_rules" {
  description = "Map of security group rules"
  type = map(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    type        = string  # "ingress" or "egress"
  }))
  default = {
    ssh = {
      description = "SSH access"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      type        = "ingress"
    }
    http = {
      description = "HTTP access"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      type        = "ingress"
    }
    https = {
      description = "HTTPS access"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      type        = "ingress"
    }
    all_outbound = {
      description = "All outbound traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      type        = "egress"
    }
  }
}

# IAM Configuration
variable "vault_external_id_infrastructure" {
  description = "External ID for infrastructure role assumption"
  type        = string
  default     = "vault-infrastructure"
}

variable "vault_external_id_s3" {
  description = "External ID for S3-only role assumption"
  type        = string
  default     = "vault-s3-only"
}

# Common tags following vault-pki-demo pattern
variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Terraform   = "true"
    Environment = "Demo"
    Owner       = "djoo"
    Project     = "vault-azdo-aws-secrets"
  }
}