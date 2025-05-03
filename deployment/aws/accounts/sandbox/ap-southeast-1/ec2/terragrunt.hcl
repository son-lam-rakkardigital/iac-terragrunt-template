include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "ec2" {
  path   = "${dirname(find_in_parent_folders("root.hcl"))}/_config/${basename(get_terragrunt_dir())}/terragrunt.hcl"
  expose = true
}

locals {
  environment = include.root.locals.environment
  region      = include.root.locals.aws_region

  env_vars = read_terragrunt_config(
    find_in_parent_folders("_config/${basename(get_terragrunt_dir())}/env/${local.region}/${local.environment}.hcl", "_config/${basename(get_terragrunt_dir())}/env/${local.environment}.hcl"),
    {
      inputs = {}
      locals = {}
    }
  )
}

inputs = merge({
  name = "ec2-instance-${local.environment}"
  tags = {
    Name = "ec2-instance-${local.environment}"
  } }, local.env_vars.inputs
)

