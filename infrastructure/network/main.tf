resource "azurerm_resource_group" "this" {
  name     = local.network_rsg_name
  location = var.location
}

resource "azurerm_virtual_network" "this" {
  name                = local.virtual_network_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = var.vnet_address_spaces

  tags = {
    environment = var.environment
    location    = var.location
  }
}
