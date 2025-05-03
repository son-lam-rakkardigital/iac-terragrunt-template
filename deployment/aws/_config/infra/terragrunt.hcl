locals {
  base_source = "${dirname(find_in_parent_folders("root.hcl"))}/modules//s3_buckets"
}

terraform {
  source = local.base_source
}

inputs = {
  enable_versioning = true
}

