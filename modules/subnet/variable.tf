variable "network_rsg_name" {
  type = string
}

variable "monitor_rsg_name" {
  type = string
}

variable "log_analytics_workspace_name" {
  type = string
}

variable "virtual_network_name" {
  type = string
}

variable "subnet_name" {
  type = string
}

variable "subnet_cidr" {
  type = string
}

variable "subnet_service_endpoints" {
  type = list(string)
}
