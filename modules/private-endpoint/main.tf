resource "azurerm_private_endpoint" "private_endpoint" {
  name                = var.private_endpoint_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = var.private_endpoint_name
    private_connection_resource_id = var.private_connection_resource_id
    is_manual_connection           = false
    subresource_names              = var.subresource_names
  }

  lifecycle {
    ignore_changes = [private_dns_zone_group]
  }

  depends_on = [
    azurerm_key_vault.this
  ]
}

resource "null_resource" "dns_query" {
  provisioner "local-exec" {
    when       = create
    on_failure = continue
    command    = <<EOT
      /usr/bin/python3 -u ${path.module}/scripts/dns_query.py --private_ip ${jsonencode(join(", ", data.azurerm_network_interface.this.ip_configuration[*].private_ip_address))} --fqdn ${local.fqdn} --time-out ${var.dns_script_timeout}
      EOT
  }

  triggers = {
    private_endpoint_id = azurerm_private_endpoint.private_endpoint.id
  }

  depends_on = [
    azurerm_private_endpoint.private_endpoint
  ]
}
