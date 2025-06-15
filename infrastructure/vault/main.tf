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

module "kv_private_endpoint" {
  source = "../../modules/private-endpoint"

  private_endpoint_name            = local.kv_pe_name
  private_connection_resource_name = azurerm_key_vault.this.name
  resource_group_name              = azurerm_resource_group.this.name
  location                         = azurerm_resource_group.this.location

  subnet_id                      = module.kv_subnet.subnet_id
  private_connection_resource_id = azurerm_key_vault.this.id
  private_dns_zone_id            = "privatelink.vaultcore.azure.net"
  subresource_names              = ["Vault"]

  depends_on = [
    azurerm_key_vault.this,
    module.kv_subnet
  ]
}
