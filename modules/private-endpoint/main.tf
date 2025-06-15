locals {
  fqdn = "${var.private_connection_resource_name}.${var.private_dns_zone_id}"
}

data "azurerm_private_dns_zone" "global_zone" {
  name                = var.private_dns_zone_id
  resource_group_name = var.global_resource_group_name
}

data "azurerm_network_interface" "this" {
  resource_group_name = var.resource_group_name
  name                = azurerm_private_endpoint.private_endpoint.network_interface[0].name
  depends_on          = [azurerm_private_endpoint.private_endpoint]
}

resource "azurerm_private_endpoint" "private_endpoint" {
  name                = var.private_endpoint_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = var.private_endpoint_name
    private_connection_resource_id = var.private_connection_resource_id
    subresource_names              = var.subresource_names
    is_manual_connection           = false
  }

  lifecycle {
    ignore_changes = [private_dns_zone_group]
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_endpoint_link" {
  name                  = "${var.private_endpoint_name}-link"
  resource_group_name   = var.global_resource_group_name
  private_dns_zone_name = data.azurerm_private_dns_zone.global_zone.name
  virtual_network_id    = var.virtual_network_id
}

resource "azurerm_private_dns_a_record" "example" {
  name                = "${var.private_endpoint_name}-a-record"
  zone_name           = data.azurerm_private_dns_zone.global_zone.name
  resource_group_name = var.global_resource_group_name
  records             = [data.azurerm_network_interface.this.private_ip_address]
  ttl                 = 600
}
