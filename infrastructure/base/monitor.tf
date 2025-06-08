resource "azurerm_resource_group" "monitor" {
  name     = local.monitor_rsg_name
  location = var.location
}

resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = local.log_ws_name
  location            = azurerm_resource_group.monitor.location
  resource_group_name = azurerm_resource_group.monitor.name

  sku               = "PerGB2018"
  retention_in_days = 30
}
