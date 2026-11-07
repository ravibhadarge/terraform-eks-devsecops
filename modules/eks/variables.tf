variable "cluster_name" { type = string }
variable "cluster_version" { type = string }
variable "vpc_id" { type = string }
variable "private_subnet_ids" { type = list(string) }

variable "endpoint_private_access" {
  type    = bool
  default = true
}

variable "endpoint_public_access" {
  type    = bool
  default = true
}

variable "public_access_cidrs" {
  type = list(string)
  validation {
    condition     = length(var.public_access_cidrs) > 0 && alltrue([for cidr in var.public_access_cidrs : can(cidrhost(cidr, 0))])
    error_message = "Provide at least one valid CIDR; do not use 0.0.0.0/0 for an administrator endpoint."
  }
}

variable "enabled_cluster_log_types" {
  type    = list(string)
  default = ["api", "audit", "authenticator"]
}

variable "log_retention_days" {
  type    = number
  default = 7
}

variable "addon_vpc_cni_version" { type = string }
variable "addon_coredns_version" { type = string }
variable "addon_kube_proxy_version" { type = string }

variable "tags" {
  type    = map(string)
  default = {}
}
