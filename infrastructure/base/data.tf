data "azurerm_client_config" "current" {}

data "azurerm_private_dns_zone" "kv_dns_zone" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = local.shrd_rsg_name
}

data "azurerm_network_interface" "kv_nic" {
  name                = azurerm_private_endpoint.kv_private_endpoint.network_interface[0].name
  resource_group_name = azurerm_resource_group.secrets.name
  depends_on          = [azurerm_private_endpoint.kv_private_endpoint]
}
