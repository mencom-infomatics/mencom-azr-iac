locals {

  name_prefix_app  = lower("${var.application}-${var.environment}")
  name_prefix_full = lower("${local.name_prefix_app}-${var.loc_code}")

  shrd_rsg_name    = lower("${var.application}-shrd-rsg")
  monitor_rsg_name = lower("${local.name_prefix_full}-monitor-rsg")
  log_ws_name      = lower("${local.name_prefix_full}-log-analytics-ws")
  network_rsg_name = lower("${local.name_prefix_full}-network-rsg")
  vnet_name        = lower("${local.name_prefix_full}-vnet")
  secrets_rsg_name = lower("${local.name_prefix_full}-secrets-rsg")
  kv_name          = lower("${local.name_prefix_full}-kv")
  kv_subnet_name   = lower("${local.name_prefix_app}-kv-snet")
  kv_pe_name       = lower("${local.name_prefix_app}-kv-pe")
  kv_dns_link      = lower("${local.name_prefix_full}-kv-dns-link")

}
