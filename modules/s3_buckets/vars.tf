## tf variables

variable "environment" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "bucket_name_prefix" {
  type = string
}

variable "enable_versioning" {
  type    = bool
  default = false
}
