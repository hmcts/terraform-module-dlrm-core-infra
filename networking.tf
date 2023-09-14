resource "azurerm_subnet" "this" {
  for_each             = var.subnets
  name                 = "${local.name}-${each.key}-${var.env}"
  resource_group_name  = local.subscription_vnet_map[data.azurerm_subscription.current.subscription_id].vnet_resource_group
  virtual_network_name = local.subscription_vnet_map[data.azurerm_subscription.current.subscription_id].vnet_name
  address_prefixes     = each.value.address_prefixes
  service_endpoints    = each.value.service_endpoints

  dynamic "delegation" {
    for_each = each.value.delegations != null ? each.value.delegations : {}
    content {
      name = delegation.key
      service_delegation {
        name    = delegation.value.service_name
        actions = delegation.value.actions
      }
    }
  }
}

resource "azurerm_route_table" "this" {
  for_each                      = var.route_tables
  name                          = "${local.name}-${each.key}-${var.env}"
  resource_group_name           = local.subscription_vnet_map[data.azurerm_subscription.current.subscription_id].vnet_resource_group
  disable_bgp_route_propagation = false
  location                      = var.location
  tags                          = var.common_tags
}

data "azurerm_route_table" "default" {
  name                = local.subscription_vnet_map[data.azurerm_subscription.current.subscription_id].default_route_table
  resource_group_name = local.subscription_vnet_map[data.azurerm_subscription.current.subscription_id].vnet_resource_group
}

resource "azurerm_route" "this" {
  for_each               = { for route in local.flattened_routes : "${route.route_table_key}-${route.route_key}" => route }
  name                   = each.key
  resource_group_name    = local.subscription_vnet_map[data.azurerm_subscription.current.subscription_id].vnet_resource_group
  route_table_name       = azurerm_route_table.this[each.value.route_table_key].name
  address_prefix         = each.value.route.address_prefix
  next_hop_type          = each.value.route.next_hop_type
  next_hop_in_ip_address = each.value.route.next_hop_in_ip_address
}

resource "azurerm_subnet_route_table_association" "this" {
  for_each       = { for route_table in local.flattened_subnet_route_associations : "${route_table.route_table_key}-${route_table.subnet}" => route_table }
  subnet_id      = azurerm_subnet.this[each.value.subnet].id
  route_table_id = azurerm_route_table.this[each.value.route_table_key].id
}

resource "azurerm_subnet_route_table_association" "default" {
  for_each       = { for key, value in var.subnets : key => value if value.use_default_rt == true }
  subnet_id      = azurerm_subnet.this[each.key].id
  route_table_id = data.azurerm_route_table.default.id
}

resource "azurerm_network_security_group" "this" {
  for_each            = var.network_security_groups
  name                = "${local.name}-${each.key}-${var.env}"
  resource_group_name = local.subscription_vnet_map[data.azurerm_subscription.current.subscription_id].vnet_resource_group
  location            = var.location
  tags                = var.common_tags
}

resource "azurerm_network_security_rule" "rules" {
  for_each                                   = { for rule in local.flattened_nsg_rules : "${rule.nsg_key}-${rule.rule_key}" => rule }
  network_security_group_name                = azurerm_network_security_group.this[each.value.nsg_key].name
  resource_group_name                        = local.subscription_vnet_map[data.azurerm_subscription.current.subscription_id].vnet_resource_group
  name                                       = each.key
  priority                                   = each.value.rule.priority
  direction                                  = each.value.rule.direction
  access                                     = each.value.rule.access
  protocol                                   = each.value.rule.protocol
  source_port_range                          = each.value.rule.source_port_range
  source_port_ranges                         = each.value.rule.source_port_ranges
  destination_port_range                     = each.value.rule.destination_port_range
  destination_port_ranges                    = each.value.rule.destination_port_ranges
  source_address_prefix                      = each.value.rule.source_address_prefix
  source_address_prefixes                    = each.value.rule.source_address_prefixes
  source_application_security_group_ids      = each.value.rule.source_application_security_group_ids
  destination_address_prefix                 = each.value.rule.destination_address_prefix
  destination_address_prefixes               = each.value.rule.destination_address_prefixes
  destination_application_security_group_ids = each.value.rule.destination_application_security_group_ids
  description                                = each.value.rule.description
}

resource "azurerm_subnet_network_security_group_association" "this" {
  for_each                  = { for nsg in local.flattened_subnet_nsg_associations : "${nsg.nsg_key}-${nsg.subnet}" => nsg }
  subnet_id                 = azurerm_subnet.this[each.value.subnet].id
  network_security_group_id = azurerm_network_security_group.this[each.value.nsg_key].id
}

resource "azurerm_storage_account_network_rules" "this" {
  storage_account_id = azurerm_storage_account.this.id

  default_action             = "Deny"
  virtual_network_subnet_ids = local.subnet_ids
  bypass                     = ["AzureServices"]

  lifecycle {
    ignore_changes = [
      private_link_access
    ]
  }
}
