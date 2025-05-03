## terragrunt configuration

locals {

  # Load project configuration
  project_vars = read_terragrunt_config(find_in_parent_folders("_config/project.hcl"))
  project_name = local.project_vars.locals.project_name

  # Load account and region variables
  account_vars      = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars       = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  aws_region        = local.region_vars.locals.aws_region
  aws_account_id    = local.account_vars.locals.aws_account_id
  aws_account_alias = local.account_vars.locals.aws_account_alias
  environment       = local.account_vars.locals.environment

  common_tags = {
    account      = "${local.aws_account_id}"
    environment  = "${local.environment}"
    project_name = "${local.project_name}"
  }
  name_prefix = "${local.project_name}-${local.environment}"

  common_vars = {
    name_prefix = local.name_prefix
    common_tags = local.common_tags
  }

}

# Generate AWS account specific provider block.
# Do assume_role to AWS Organizations default role
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
    region = "${local.aws_region}"
    # For testing
    # assume_role {
    #     role_arn = "arn:aws:iam::${local.aws_account_id}:role/OrganizationAccountAccessRole"
    # }

    default_tags {
        tags = {
            # account = "${local.aws_account_id}"
            environment = "${local.environment}"
            project_name = "${local.project_name}"
        }
    }
}
EOF
}

# Region specific Terraform state configuration 
remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    encrypt        = true
    bucket         = "${local.project_name}-shared-tf-states-${local.aws_account_alias}-${local.aws_region}-4ac84a50"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.aws_region
    dynamodb_table = "${local.project_name}-shared-${local.aws_account_alias}-${local.aws_region}-terraform-locks-4ac84a50"
  }
}

#Combine all variables
inputs = merge(
  local.common_vars,
  local.account_vars.locals,
  local.region_vars.locals,
)


# retry configuration
errors {
  retry "source_fetch" {
    retryable_errors   = [".*Error: transient network issue.*", ".*to obtain schema: timeout while waiting for plugin.*"]
    max_attempts       = 3
    sleep_interval_sec = 10
  }
}
