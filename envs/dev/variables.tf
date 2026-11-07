variable "aws_region" {
  description = "AWS region for the development environment."
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  type    = string
  default = "devsecops-dev"
}

variable "cluster_version" {
  description = "Confirm regional EKS support before applying."
  type        = string
  default     = "1.35"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "az_count" {
  type    = number
  default = 2
}

variable "enable_nat_gateway" {
  type    = bool
  default = true
}

variable "admin_public_access_cidr" {
  description = "Your current public IPv4 address in CIDR notation, e.g. 203.0.113.10/32. Never use 0.0.0.0/0."
  type        = string
  validation {
    condition     = can(cidrhost(var.admin_public_access_cidr, 0)) && !contains(["0.0.0.0/0", "::/0"], var.admin_public_access_cidr)
    error_message = "Set a valid, narrow administrator CIDR such as your.public.ip/32."
  }
}

variable "node_instance_types" {
  type    = list(string)
  default = ["c7i-flex.large"]
}

variable "node_capacity_type" {
  description = "Use SPOT for the cost-conscious lab; switch to ON_DEMAND for stable baseline capacity."
  type        = string
  default     = "SPOT"
  validation {
    condition     = contains(["SPOT", "ON_DEMAND"], var.node_capacity_type)
    error_message = "node_capacity_type must be SPOT or ON_DEMAND."
  }
}

variable "node_min_size" {
  type    = number
  default = 2
}

variable "node_desired_size" {
  type    = number
  default = 2
}

variable "node_max_size" {
  type    = number
  default = 3
}
