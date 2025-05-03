locals {
  environment    = "sandbox"
  aws_account_id = get_aws_account_id()
  aws_account_alias = basename(get_terragrunt_dir())

}
