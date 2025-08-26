variable "name_prefix" {
  type        = string
  description = "The prefix for the name of the resources"
}

variable "common_tags" {
  type        = map(string)
  description = "The common tags for the resources"
}

variable "aws_account_alias" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "environment" {
  type = string
}

variable "extend_variable" {
  type = map(string)
  # It can be overwritten
  default = {}
}

variable "custom_variable" {
  type = string
}
