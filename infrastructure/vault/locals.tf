locals {

  # Common Variables
  name_prefix = lower("${var.team}-${var.loc_code}-${var.env_code}")

  # Foreign Resources
  monitor_rsg_name = lower("${local.name_prefix}-monitor-rsg")
  law_name         = lower("${local.name_prefix}-log-analytics-ws")

  network_rsg_name = lower("${local.name_prefix}-network-rsg")
  vnet_name        = lower("${local.name_prefix}-vnet")

  # Vault Resources
  vault_rsg_name = lower("${local.name_prefix}-vault-rsg")
  kv_name        = lower("${local.name_prefix}-kv")
  kv_subnet_name = lower("${local.name_prefix}-kv-snet")
  kv_pe_name     = lower("${local.name_prefix}-kv-private-endpoint")

}
