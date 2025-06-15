resource "azurerm_resource_group" "this" {
  name     = local.vault_rsg_name
  location = var.location
}

# Create Subnet
module "kv_subnet" {
  source = "../../modules/subnet"

  subnet_name      = local.kv_subnet_name
  network_rsg_name = data.azurerm_virtual_network.vnet.resource_group_name
  monitor_rsg_name = data.azurerm_log_analytics_workspace.law.resource_group_name

  virtual_network_name         = data.azurerm_virtual_network.vnet.name
  log_analytics_workspace_name = data.azurerm_log_analytics_workspace.law.name

  subnet_cidr              = var.kv_subnet_cidr
  subnet_service_endpoints = []
}

# Create Key Vault
resource "azurerm_key_vault" "this" {
  name                = local.kv_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  sku_name                   = var.kv_sku_name
  soft_delete_retention_days = var.kv_soft_delete_retention_days

  enable_rbac_authorization       = true
  purge_protection_enabled        = true
  public_network_access_enabled   = false
  enabled_for_disk_encryption     = true
  enabled_for_template_deployment = true
  enabled_for_deployment          = true

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }

  depends_on = [
    module.kv_subnet
  ]
}

resource "azurerm_role_assignment" "kv_admin_role_assignment" {
  role_definition_name = "Key Vault Administrator"
  scope                = azurerm_key_vault.this.id
  principal_id         = var.kv_admin_object_id

  depends_on = [
    azurerm_key_vault.this
  ]
}

resource "azurerm_private_endpoint" "kv_pe" {
  name                = "${local.kv_name}-private-endpoint"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  subnet_id           = module.kv_subnet.subnet_id

  private_service_connection {
    name                           = "${local.kv_name}-private-connection"
    private_connection_resource_id = azurerm_key_vault.this.id
    is_manual_connection           = false
    subresource_names              = ["Vault"]
  }

  depends_on = [
    azurerm_key_vault.this
  ]
}

resource "azurerm_private_dns_zone" "kv_dns_zone" {
  name                = "${local.kv_name}.privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_private_dns_a_record" "kv_dns_a_record" {
  name                = local.kv_name
  zone_name           = azurerm_private_dns_zone.kv_dns_zone.name
  resource_group_name = azurerm_resource_group.this.name
  ttl                 = 300
  records = [
    azurerm_private_endpoint.kv_pe.private_service_connection[0].private_ip_address
  ]
}

resource "azurerm_private_dns_zone_virtual_network_link" "kv_dns_zone_vnet_link" {
  name                  = "${local.kv_name}-vnet-dns-link"
  resource_group_name   = azurerm_resource_group.this.name
  private_dns_zone_name = azurerm_private_dns_zone.kv_dns_zone.name
  virtual_network_id    = data.azurerm_virtual_network.vnet.id
  depends_on            = [azurerm_private_endpoint.kv_pe]
}
