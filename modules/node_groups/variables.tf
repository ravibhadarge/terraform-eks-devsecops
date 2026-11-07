variable "cluster_name" { type = string }
variable "private_subnet_ids" { type = list(string) }
variable "node_security_group_ids" { type = list(string) }

variable "instance_types" {
  type    = list(string)
  default = ["t3.medium"]
}

variable "disk_size" {
  type    = number
  default = 35
}

variable "desired_size" {
  type    = number
  default = 2
}

variable "min_size" {
  type    = number
  default = 2
}

variable "max_size" {
  type    = number
  default = 3
}

variable "capacity_type" {
  type    = string
  default = "ON_DEMAND"
  validation {
    condition     = contains(["ON_DEMAND", "SPOT"], var.capacity_type)
    error_message = "capacity_type must be ON_DEMAND or SPOT."
  }
}

variable "node_labels" {
  type    = map(string)
  default = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}
