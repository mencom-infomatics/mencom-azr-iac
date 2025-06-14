resource "azurerm_resource_group" "network" {
  name     = local.network_rsg_name
  location = var.location
}

resource "azurerm_virtual_network" "virtual_network" {
  name                = local.virtual_network_name
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  address_space       = var.vnet_address_spaces

  tags = {
    environment = var.environment
    location    = var.location
  }
}
