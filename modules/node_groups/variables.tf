variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "instance_types" {
  type    = list(string)
  default = ["t3.small"]
}

variable "ami_id" {
  type    = string
  default = ""
}

variable "disk_size" {
  type    = number
  default = 50
}

variable "key_name" {
  type    = string
  default = null
}

variable "desired_size" {
  type    = number
  default = 2
}

variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 3
}

variable "capacity_type" {
  type    = string
  default = "ON_DEMAND"
}

variable "node_labels" {
  type    = map(string)
  default = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}
