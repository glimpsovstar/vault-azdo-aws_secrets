# Azure DevOps + HashiCorp Vault AWS Secrets Engine Integration Demo

## Overview
This demo showcases two authentication patterns for Azure DevOps pipelines to obtain AWS credentials from HashiCorp Vault:
1. **OIDC/JWT Authentication**: Service-to-service authentication with broad AWS permissions
2. **Entra ID Group-Based Authentication**: User-based authentication with limited AWS permissions

## Prerequisites

### Required Components
- HashiCorp Vault instance (can use HCP Vault or self-hosted)
- Azure DevOps organization with pipelines enabled
- AWS account with appropriate IAM permissions
- Azure AD (Entra ID) tenant with configured groups
- Terraform installed (for infrastructure provisioning)

## Quick Start

1. **Setup environment and deploy infrastructure**
   ```bash
   # Run the enhanced setup script (uses your existing djoo tooling)
   ./scripts/setup.sh
   ```

   This script will:
   - Use `vault-env` to configure HCP Vault connection
   - Use `dmcred` to setup AWS credentials from doormat
   - Deploy AWS IAM roles via Terraform
   - Deploy Vault configuration via Terraform

2. **Configure Azure DevOps values**
   ```bash
   # Edit the auto-generated file with your Azure DevOps and Entra ID details
   vim terraform/vault-config/terraform.auto.tfvars
   ```

3. **Deploy pipelines to Azure DevOps**
   - Copy `pipelines/azure-pipelines-oidc.yml` to your Azure DevOps project
   - Copy `pipelines/azure-pipelines-entraid.yml` to your Azure DevOps project
   - Configure service connections as described in documentation

## Project Structure

```
.
├── README.md
├── scripts/
│   ├── setup.sh                     # Main setup script (uses vault-env + dmcred)
│   └── cleanup.sh                   # Cleanup script
├── terraform/
│   ├── vault-config/                # Vault configuration via Terraform
│   │   ├── providers.tf
│   │   ├── variables.tf
│   │   ├── aws-secrets-engine.tf
│   │   ├── auth-jwt.tf              # Azure DevOps OIDC auth
│   │   ├── auth-oidc.tf             # Entra ID auth
│   │   ├── policies.tf
│   │   ├── outputs.tf
│   │   └── terraform.auto.tfvars.example
│   └── aws-infrastructure/          # AWS IAM roles and infrastructure
│       ├── providers.tf
│       ├── variables.tf
│       └── security_groups.tf
├── pipelines/
│   ├── azure-pipelines-oidc.yml     # Service account pipeline (full permissions)
│   └── azure-pipelines-entraid.yml  # User-based pipeline (S3-only)
├── policies/                        # Legacy HCL policies (for reference)
├── aws-iam/                         # Legacy AWS setup (for reference)
└── docs/
    ├── SETUP.md
    ├── TROUBLESHOOTING.md
    └── SECURITY.md
```

## Documentation

- [Detailed Setup Guide](docs/SETUP.md)
- [Troubleshooting Guide](docs/TROUBLESHOOTING.md)
- [Security Best Practices](docs/SECURITY.md)

## Security Considerations

This demo implements several security best practices:
- **Dynamic credentials** - No static AWS keys stored
- **Principle of least privilege** - Role-based access control
- **Short-lived tokens** - All credentials have TTL
- **Audit trail** - All actions logged in Vault

## License

This demo is provided as-is for educational purposes.

# Trigger new build - Fri 19 Sep 2025 06:23:39 AEST
