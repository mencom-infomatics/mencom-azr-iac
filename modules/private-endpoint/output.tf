output "private_endpoint_ip" {
  description = "The ID of the subnet."
  value       = data.azurerm_network_interface.this.ip_configuration[*].private_ip_address
}
