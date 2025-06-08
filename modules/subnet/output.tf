output "subnet_id" {
  description = "The ID of the subnet."
  value       = azurerm_subnet.this.id
}

output "subnet_name" {
  description = "The name of the subnet."
  value       = azurerm_subnet.this.name
}

output "subnet_address_prefixes" {
  description = "The address prefixes of the subnet."
  value       = azurerm_subnet.this.address_prefixes
}

output "nsg" {
  description = "All outputs from the NSG module"
  value = {
    id   = module.subnet_nsg.nsg_id
    name = module.subnet_nsg.nsg_name
  }
}
