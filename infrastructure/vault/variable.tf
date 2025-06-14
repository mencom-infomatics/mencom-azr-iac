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

# Key Vault configs
variable "kv_sku_name" {
  description = "Key Vault SKU name"
  type        = string
  default     = "standard"
}

variable "kv_soft_delete_retention_days" {
  description = "Key Vault delete_retention_days"
  type        = number
  default     = 7
}

variable "kv_subnet_cidr" {
  description = "Key Vault subnet CIDR"
  type        = string
}

variable "kv_admin_object_id" {
  description = "The object ID of the admin user or service principal."
  type        = string
}
