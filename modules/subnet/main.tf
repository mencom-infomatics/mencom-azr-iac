resource "azurerm_subnet" "this" {
  name                 = var.subnet_name
  resource_group_name  = data.azurerm_resource_group.network_rsg.name
  virtual_network_name = data.azurerm_virtual_network.virtual_network.name
  address_prefixes     = [var.subnet_cidr]
  service_endpoints    = var.subnet_service_endpoints
}

module "subnet_nsg" {
  source = "../network-security-group"

  subnet_name          = azurerm_subnet.this.name
  resource_group_name  = data.azurerm_resource_group.network_rsg.name
  virtual_network_name = data.azurerm_virtual_network.virtual_network.name

  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.log_workspace.id

  depends_on = [
    azurerm_subnet.this
  ]
}
