# ec2/terragrunt.hcl
terraform {
  source = "tfr:///terraform-aws-modules/ec2-instance/aws?version=5.7.1"
}

dependency "vpc" {
  config_path = "${get_terragrunt_dir()}/../vpc"

  mock_outputs = {
    private_subnets = ["sub-abcdef12"]
  }
}

inputs = {
  # It will be overwrite
  # name          = "single-instance"
  instance_type = "t2.micro"
  monitoring    = true
  subnet_id     = dependency.vpc.outputs.private_subnets[0]
  metadata_options = {

    "http_endpoint"               = "enabled"
    "http_put_response_hop_limit" = 1
    "http_tokens"                 = "required"
  }
}
