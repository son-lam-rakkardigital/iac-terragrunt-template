include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "infra" {
  path   = "${dirname(find_in_parent_folders("root.hcl"))}/_config/${basename(get_terragrunt_dir())}/terragrunt.hcl"
  expose = true
}


locals {
  environment  = include.root.locals.environment
  region       = include.root.locals.aws_region
  project_name = include.root.locals.project_name
  name_prefix  = include.root.locals.name_prefix

  env_vars = read_terragrunt_config(
    find_in_parent_folders("_config/${basename(get_terragrunt_dir())}/env/${local.region}/${local.environment}.hcl", "_config/${basename(get_terragrunt_dir())}/env/${local.environment}.hcl"),
    {
      inputs = {}
      locals = {}
    }
  )
}

inputs = merge({
  bucket_name_prefix = "${local.name_prefix}-${local.region}"
  }, local.env_vars.inputs
)

