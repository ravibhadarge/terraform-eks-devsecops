variable "cluster_name" {
  type = string
}

variable "name" {
  type = string
}

variable "oidc_provider" {
  type = string
}

variable "oidc_provider_arn" {
  type = string
}

variable "service_account" {
  type = string
}

variable "policy_json" {
  type    = string
  default = ""
}

variable "managed_policy_arns" {
  type    = list(string)
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}
