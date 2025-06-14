# Create Monitoring Resource Group
resource "azurerm_resource_group" "this" {
  name     = local.network_rsg_name
  location = var.location
}

# Create Virtual Network
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

# Create a Diagnostic Setting for the Virtual Network.
resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = "diagnostic settings"
  target_resource_id         = azurerm_virtual_network.this.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.this.id

  # The log block represents a log category.
  # Replace the below category with one available for Virtual Network if needed.

  enabled_log {
    category       = "VMProtectionAlerts"
  }

  # The metric block configures metrics collection.
  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
