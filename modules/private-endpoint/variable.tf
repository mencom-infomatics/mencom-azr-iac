variable "subnet_id" {
  type = string
}

variable "private_dns_zone_id" {
  type = string
}

variable "subresource_names" {
  type = list(string)
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "private_connection_resource_id" {
  type = string
}

variable "private_connection_resource_name" {
  type = string
}

variable "virtual_network_id" {
  type = string
}

variable "dns_script_timeout" {
  type    = number
  default = 900
}

variable "global_resource_group_name" {
  type = string
}
