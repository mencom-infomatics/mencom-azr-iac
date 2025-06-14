data "azurerm_client_config" "current" {}

data "azurerm_log_analytics_workspace" "law" {
  name                = local.law_name
  resource_group_name = local.monitor_rsg_name
}

data "azurerm_virtual_network" "vnet" {
  name                = local.vnet_name
  resource_group_name = local.network_rsg_name
}
