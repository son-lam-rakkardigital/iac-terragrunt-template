# iac-terragrunt-template
This project provisions S3 bucket from Terraform module to sandbox accounts using Terragrunt.

The S3 bucket module supports optional versioning via the `enable_versioning` variable, which defaults to `false`.

# Preconfiguration

Starter template for managing infrastructure as code with Terraform modules orchestrated by Terragrunt. It demonstrates how to provision AWS resources—S3 buckets, VPCs, and EC2 instances—across multiple accounts and regions.

## Repository Layout
```
iac-terragrunt-template/
├── README.md
├── modules/                # Stand-alone Terraform modules (simple examples)
└── deployment/
    └── aws/
        ├── root.hcl        # Core Terragrunt configuration
        ├── _config/        # Component templates & env overrides
        ├── accounts/       # Per-account & per-region deployments
        └── modules/        # Terraform modules used in deployments
```

## Preconfiguration

Before running any Terragrunt commands, set the `project_name` in `deployment/aws/_config/project.hcl`:

```hcl
locals {
  project_name = "PROJECT_NAME_PLACE_HOLDER"
}
```

## Running Terragrunt

Change into the accounts directory and run:

```bash
cd deployment/aws/accounts
terragrunt run-all plan
```

To plan or apply a single account or component:

```bash
terragrunt run-all plan --working-dir sandbox/ap-southeast-1
terragrunt run-all plan --working-dir sandbox/ap-southeast-1/vpc
```

## Next Steps

- Review `_config/<module>/terragrunt.hcl` to understand shared inputs and environment overrides.
- Explore `deployment/aws/modules/` for the Terraform code behind each component.
- Learn more about Terragrunt features like `include`, `find_in_parent_folders`, and `dependency` to extend this template.
