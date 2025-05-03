include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "debuging" {
  path   = "${dirname(find_in_parent_folders("root.hcl"))}/_config/${basename(get_terragrunt_dir())}/terragrunt.hcl"
  expose = true
}

locals {
  environment              = include.root.locals.environment
  region                   = include.root.locals.aws_region
  project_name             = include.root.locals.project_name
  base_source_debug_module = include.debuging.locals.base_source


  env_vars = read_terragrunt_config(
    find_in_parent_folders("_config/${basename(get_terragrunt_dir())}/env/${local.region}/${local.environment}.hcl", "_config/${basename(get_terragrunt_dir())}/env/${local.environment}.hcl"),
    {
      inputs = {}
      locals = {}
    }
  )


  find_in_parent_folders_root = find_in_parent_folders("root.hcl")


  base_source_modules = dirname(find_in_parent_folders("root.hcl"))

  # Check include "root"
  base_source_modules_using_get_parent_terragrunt_dir = get_parent_terragrunt_dir("root")

  # Using to read config from root.h
  path_to_root_from_current_dir = dirname(find_in_parent_folders("root.hcl"))
  # Using as key for the state file
  path_from_root_to_current_dir = path_relative_to_include("root")

  base_source_debug_module_auto_detect_current_dir = "${path_relative_from_include("root")}/modules//${basename(path_relative_to_include("root"))}"

  # Example - "./.terragrunt-cache/HVMvklN3gzuhoHNhcXKPOxXGKTc/B-_KNYYNANG0cr9p8fHtrLu84J8/debuging"
  current_working_dir = get_working_dir()
  terragrunt_dir      = get_terragrunt_dir()

  # Find path from current terragrunt to _config folder
  parent_folders_config             = find_in_parent_folders("_config")
  parent_folders_config_project_hcl = find_in_parent_folders("_config/project.hcl")


}

inputs = merge({
  extend_variable = {
    "project_name" = "${local.project_name}"

    "base_source_modules"                                 = "${local.base_source_modules}"
    "base_source_modules_using_get_parent_terragrunt_dir" = "${local.base_source_modules_using_get_parent_terragrunt_dir}"

    "base_source_debug_module"      = "${local.base_source_debug_module}"
    "find_in_parent_folders_root"   = "${local.find_in_parent_folders_root}"
    "path_to_root_from_current_dir" = "${local.path_to_root_from_current_dir}"
    "path_from_root_to_current_dir" = "${local.path_from_root_to_current_dir}"

    base_source_debug_module_auto_detect_current_dir = "${local.base_source_debug_module_auto_detect_current_dir}"


    current_working_dir = "${local.current_working_dir}"
    terragrunt_dir      = "${local.terragrunt_dir}"

    parent_folders_config = "${local.parent_folders_config}"

    parent_folders_config_project_hcl = "${local.parent_folders_config_project_hcl}"
    # parent_terragrunt_dir = "${local.parent_terragrunt_dir}"
  }

  }, local.env_vars.inputs
)


