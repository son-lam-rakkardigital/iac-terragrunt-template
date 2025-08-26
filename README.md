# iac-terragrunt-template
This project provisions S3 bucket from Terraform module to sandbox accounts using Terragrunt.

The S3 bucket module supports optional versioning via the `enable_versioning` variable, which defaults to `false`.

# Preconfiguration

Before running any Terragrunt commands, ensure that the `project_name` is set in the `locals` block in `deployment/aws/_config/project.hcl`. This is required for proper configuration.

Add the following `locals` block to your Terragrunt configuration file:

```hcl
locals {
    project_name = "PROJECT_NAME_PLACE_HOLDER"
}
```

This will define the `project_name` variable, which can be used throughout your Terragrunt configuration.
```
cd iac-terragrunt-template/deployment/aws/accounts

terragrunt run-all plan
```

# Running for each account or component

```bash
cd iac-terragrunt-template/deployment/aws/accounts 
terragrunt run-all plan --working-dir accounts/sandbox/ap-southeast-1
terragrunt run-all plan --working-dir accounts/sandbox/ap-southeast-1/vpc
```
