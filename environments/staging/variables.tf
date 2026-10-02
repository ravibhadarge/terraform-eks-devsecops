variable "aws_region" {
  default = "us-east-1"
}

variable "environment" {
  default = "staging"
}

variable "cluster_name" {
  default = "devsecops-staging"
}

variable "cluster_version" {
  default = "1.30"
}

variable "vpc_cidr" {
  default = "10.1.0.0/16"
}

variable "az_count" {
  default = 3
}

variable "enable_nat_gateway" {
  default = true
}

variable "endpoint_private_access" {
  default = true
}

variable "endpoint_public_access" {
  default = true
}

variable "public_access_cidrs" {
  default = ["0.0.0.0/0"]
}

variable "enabled_cluster_log_types" {
  default = ["api", "audit", "authenticator"]
}

variable "log_retention_days" {
  default = 7
}

variable "addon_vpc_cni_version" {
  default = "v1.18.0-eksbuild.1"
}

variable "addon_coredns_version" {
  default = "v1.11.1-eksbuild.6"
}

variable "addon_kube_proxy_version" {
  default = "v1.30.0-eksbuild.3"
}

variable "addon_ebs_csi_version" {
  default = "v1.31.0-eksbuild.1"
}

variable "instance_types" {
  default = ["t3.medium"]
}

variable "desired_size" {
  default = 2
}

variable "min_size" {
  default = 2
}

variable "max_size" {
  default = 5
}

variable "capacity_type" {
  default = "ON_DEMAND"
}

variable "disk_size" {
  default = 50
}

variable "enable_guardduty" {
  default = true
}

variable "enable_securityhub" {
  default = true
}

variable "enable_cert_manager" {
  default = true
}

variable "enable_metrics_server" {
  default = true
}

