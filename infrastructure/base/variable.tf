# Common Variables
variable "application" {
  description = "Name of application"
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

variable "kv_admin_object_id" {
  description = "The object ID of the admin user or service principal."
  type        = string
}
