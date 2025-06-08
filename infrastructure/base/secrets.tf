resource "azurerm_resource_group" "secrets" {
  name     = local.secrets_rsg_name
  location = var.location
}

resource "azurerm_key_vault" "this" {
  name                = local.kv_name
  location            = azurerm_resource_group.secrets.location
  resource_group_name = azurerm_resource_group.secrets.name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  sku_name                        = "standard"
  enabled_for_disk_encryption     = true
  enabled_for_template_deployment = true
  enabled_for_deployment          = true
  purge_protection_enabled        = true
  enable_rbac_authorization       = true
  public_network_access_enabled   = false
  soft_delete_retention_days      = 7

  network_acls {
    default_action             = "Deny"
    bypass                     = "AzureServices"
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }

}

module "kv_subnet" {
  source = "../../modules/subnet"

  subnet_name      = local.kv_subnet_name
  network_rsg_name = azurerm_resource_group.network.name
  monitor_rsg_name = azurerm_resource_group.monitor.name

  virtual_network_name         = azurerm_virtual_network.virtual_network.name
  log_analytics_workspace_name = azurerm_log_analytics_workspace.log_analytics_workspace.name

  subnet_cidr              = "10.10.0.0/29"
  subnet_service_endpoints = []

  depends_on = [
    azurerm_virtual_network.virtual_network,
    azurerm_log_analytics_workspace.log_analytics_workspace
  ]
}

# Create an example role assignment for a principal to access the Key Vault.
# Replace with the desired role: e.g., "Key Vault Secrets User" or "Key Vault Administrator".
resource "azurerm_role_assignment" "kv_admin_role_assignment" {
  role_definition_name = "Key Vault Administrator"
  scope                = azurerm_key_vault.this.id
  principal_id         = var.kv_admin_object_id # The object ID of your identity.
}

resource "azurerm_private_endpoint" "kv_private_endpoint" {
  name                = local.kv_pe_name
  location            = azurerm_resource_group.secrets.location
  resource_group_name = azurerm_resource_group.secrets.name
  subnet_id           = module.kv_subnet.subnet_id

  private_service_connection {
    name                           = local.kv_pe_name
    private_connection_resource_id = azurerm_key_vault.this.id
    is_manual_connection           = false
    subresource_names              = ["vault"] # This is the required subresource name.
  }

  lifecycle {
    ignore_changes = [private_dns_zone_group]
  }

  depends_on = [
    module.kv_subnet,
    azurerm_key_vault.this
  ]
}
 
# Automatically create an A record in the DNS zone for the private endpoint.
resource "azurerm_private_dns_a_record" "kv_dns_record" {
  name                = azurerm_key_vault.this.name
  zone_name           = data.azurerm_private_dns_zone.kv_dns_zone.name
  resource_group_name = azurerm_resource_group.secrets.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.kv_private_endpoint.private_service_connection[0].private_ip_address]

  depends_on = [
    azurerm_private_endpoint.kv_private_endpoint
  ]
}
