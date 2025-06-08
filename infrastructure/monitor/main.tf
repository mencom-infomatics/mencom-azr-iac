resource "azurerm_resource_group" "this" {
  name     = local.monitor_rsg_name
  location = var.location
}

resource "azurerm_log_analytics_workspace" "this" {
  name                = local.log_analytics_ws_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  sku               = var.law_sku
  retention_in_days = var.law_retention_in_days

  tags = {
    environment = var.environment
    location    = var.location
  }
}
