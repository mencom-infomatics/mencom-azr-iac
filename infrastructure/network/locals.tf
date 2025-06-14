locals {

  # Common Variables
  name_prefix = lower("${var.team}-${var.loc_code}-${var.env_code}")

  # Monitring rsg related
  network_rsg_name     = lower("${local.name_prefix}-network-rsg")
  virtual_network_name = lower("${local.name_prefix}-vnet")

}
