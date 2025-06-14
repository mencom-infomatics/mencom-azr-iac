locals {

  # Common Variables
  name_prefix = lower("${var.team}-${var.loc_code}-${var.env_code}")

  # Network rsg related
  network_rsg_name     = lower("${local.name_prefix}-network-rsg")
  virtual_network_name = lower("${local.name_prefix}-vnet")

  # Monitoring rsg related
  monitor_rsg_name      = lower("${local.name_prefix}-monitor-rsg")
  log_analytics_ws_name = lower("${local.name_prefix}-log-analytics-ws")

}
