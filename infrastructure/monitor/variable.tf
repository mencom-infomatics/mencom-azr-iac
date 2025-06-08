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

# Log Analytics - Config Details
variable "law_sku" {
  description = "Log Analytics Workspace sku"
  default     = "PerGB2018"
  type        = string
}

variable "law_retention_in_days" {
  description = "Log Analytics Workspace retention_in_days"
  default     = 30
  type        = number
}
