resource "azurerm_network_security_group" "this" {
  name                = lower("${var.subnet_name}-nsg")
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name

  lifecycle {
    ignore_changes = [security_rule]
  }
}

resource "azurerm_subnet_network_security_group_association" "this" {
  subnet_id                 = data.azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.this.id
}

resource "azurerm_network_security_rule" "this" {
  for_each = { for rule in [
    {
      name                       = "Incoming-Allow-TCP-22"
      description                = "Added by Terraform Automation - Allow TCP/22"
      priority                   = 1001
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = "VirtualNetwork"
      source_port_range          = "*"
      destination_address_prefix = "VirtualNetwork"
      destination_port_range     = "22"
    },
    {
      name                       = "Incoming-Allow-TCP-3389"
      description                = "Added by Terraform Automation - Allow TCP/3389"
      priority                   = 1002
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = "VirtualNetwork"
      source_port_range          = "*"
      destination_address_prefix = "VirtualNetwork"
      destination_port_range     = "3389"
    },
    {
      name                       = "Incoming-Allow-ICMP-0"
      description                = "Added by Terraform Automation - Allow ICMP/0"
      priority                   = 1003
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Icmp"
      source_address_prefix      = "VirtualNetwork"
      source_port_range          = "*"
      destination_address_prefix = "VirtualNetwork"
      destination_port_range     = "0"
    },
    {
      name                       = "Incoming-Allow-TCP-443"
      description                = "Added by Terraform Automation - Allow TCP/443"
      priority                   = 1004
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = "VirtualNetwork"
      source_port_range          = "*"
      destination_address_prefix = "VirtualNetwork"
      destination_port_range     = "443"
    }
  ] : rule.name => rule }

  name                        = each.value["name"]
  resource_group_name         = data.azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.this.name

  description = each.value["description"]
  priority    = each.value["priority"]
  direction   = each.value["direction"]
  access      = each.value["access"]
  protocol    = each.value["protocol"]

  source_address_prefix      = each.value["source_address_prefix"]
  destination_address_prefix = each.value["destination_address_prefix"]

  source_port_range      = each.value["source_port_range"]
  destination_port_range = each.value["destination_port_range"]
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = "${azurerm_network_security_group.this.name}-mds"
  target_resource_id         = azurerm_network_security_group.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "NetworkSecurityGroupEvent"
  }

  enabled_log {
    category = "NetworkSecurityGroupRuleCounter"
  }
}
