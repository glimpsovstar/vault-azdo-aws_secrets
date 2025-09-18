# AWS Configuration
aws_account_id = "275757819310"  # Your personal AWS account
aws_region     = "ap-southeast-1"  # Singapore region (close to Australia)

# Project Configuration
project_name = "vault-azdo-demo"
environment  = "demo"

# Network Configuration
vpc_cidr = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.10.0/24", "10.0.20.0/24"]

# Security Group Rules (demo_aws_ec2_app pattern)
security_group_rules = {
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
