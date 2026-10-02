variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type    = string
  default = "1.35"
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "endpoint_private_access" {
  type    = bool
  default = true
}

variable "endpoint_public_access" {
  type    = bool
  default = true
}

variable "public_access_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "enabled_cluster_log_types" {
  type    = list(string)
  default = ["api", "audit", "authenticator"]
}

variable "log_retention_days" {
  type    = number
  default = 7
}

variable "addon_vpc_cni_version" {
  type = string
}

variable "addon_coredns_version" {
  type = string
}

variable "addon_kube_proxy_version" {
  type = string
}

variable "addon_ebs_csi_version" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
