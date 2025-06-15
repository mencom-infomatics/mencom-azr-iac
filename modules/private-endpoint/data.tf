data "azurerm_network_interface" "this" {
  resource_group_name = var.resource_group_name
  name                = azurerm_private_endpoint.private_endpoint.network_interface[0].name
  depends_on          = [azurerm_private_endpoint.private_endpoint]
}
