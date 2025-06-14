data "azurerm_client_config" "current" {}

data "azurerm_log_analytics_workspace" "this" {
  name                = local.log_analytics_ws_name
  resource_group_name = local.monitor_rsg_name
}
