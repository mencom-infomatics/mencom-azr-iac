# Common Variables
variable "team" {
  description = "Name of team"
  type        = string
}

variable "location" {
  description = "Location of the resource"
  type        = string
}

variable "loc_code" {
  description = "Location Code of the resource"
  type        = string
}

variable "environment" {
  description = "Environment for deployment"
  type        = string
}

variable "env_code" {
  description = "Environment code"
  type        = string
}

# Virtual Network - Config Details
variable "vnet_address_spaces" {
  description = "Virtual Network Address spaces cidrs"
  type        = list(string)
}
