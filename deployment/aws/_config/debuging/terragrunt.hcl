locals {
  # base_source = "${dirname(find_in_parent_folders("root.hcl"))}/modules//debuging"
  # Name of folder is the same as module name
  base_source = "${dirname(find_in_parent_folders("root.hcl"))}/modules//${basename(get_terragrunt_dir())}"

}

terraform {
  source = local.base_source
}
