variable "cluster_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "enable_aws_load_balancer_controller" {
  type    = bool
  default = true
}

variable "aws_load_balancer_controller_version" {
  type    = string
  default = "1.7.1"
}

variable "aws_load_balancer_controller_role_arn" {
  type    = string
  default = ""
}

variable "enable_cert_manager" {
  type    = bool
  default = true
}

variable "cert_manager_version" {
  type    = string
  default = "v1.14.0"
}

variable "cert_manager_role_arn" {
  type    = string
  default = ""
}

variable "enable_external_dns" {
  type    = bool
  default = true
}

variable "external_dns_version" {
  type    = string
  default = "1.14.0"
}

variable "external_dns_role_arn" {
  type    = string
  default = ""
}

variable "enable_metrics_server" {
  type    = bool
  default = true
}

variable "metrics_server_version" {
  type    = string
  default = "3.11.0"
}
