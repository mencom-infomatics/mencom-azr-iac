data "azurerm_resource_group" "network_rsg" {
  name = var.network_rsg_name
}

data "azurerm_resource_group" "monitor_rsg" {
  name = var.monitor_rsg_name
}

data "azurerm_virtual_network" "virtual_network" {
  name                = var.virtual_network_name
  resource_group_name = data.azurerm_resource_group.network_rsg.name
}

data "azurerm_log_analytics_workspace" "log_workspace" {
  name                = var.log_analytics_workspace_name
  resource_group_name = data.azurerm_resource_group.monitor_rsg.name
}
