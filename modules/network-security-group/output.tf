output "nsg_id" {
  description = "The ID of the Network Security Group."
  value       = azurerm_network_security_group.this.id
}

output "nsg_name" {
  description = "The name of the Network Security Group."
  value       = azurerm_network_security_group.this.name
}

output "nsg_resource_group" {
  description = "The resource group of the Network Security Group."
  value       = azurerm_network_security_group.this.resource_group_name
}
