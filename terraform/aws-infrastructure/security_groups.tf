# Security Groups (following demo_aws_ec2_app patterns)

# Main security group for demo instances
resource "aws_security_group" "demo" {
  name_prefix = "${var.project_name}-demo-"
  description = "Security group for Vault Azure DevOps demo"
  vpc_id      = aws_vpc.main.id

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-demo-sg"
  })
}

# Dynamic security group rules using for_each (demo_aws_ec2_app pattern)
resource "aws_security_group_rule" "demo_rules" {
  for_each = var.security_group_rules

  type        = each.value.type
  from_port   = each.value.from_port
  to_port     = each.value.to_port
  protocol    = each.value.protocol
  cidr_blocks = each.value.cidr_blocks
  description = each.value.description

  security_group_id = aws_security_group.demo.id
}

# Security group for Vault agent instances
resource "aws_security_group" "vault_agent" {
  name_prefix = "${var.project_name}-vault-agent-"
  description = "Security group for instances with Vault agent"
  vpc_id      = aws_vpc.main.id

  # Allow SSH from demo security group
  ingress {
    description     = "SSH from demo instances"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.demo.id]
  }

  # Allow internal communication
  ingress {
    description = "Internal communication"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    self        = true
  }

  # All outbound traffic
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-vault-agent-sg"
  })
}