resource "azurerm_subnet" "this" {
  for_each             = var.subnets
  name                 = "${local.name}-${each.key}-${var.env}"
  resource_group_name  = local.subscription_vnet_map[data.azurerm_subscription.current.subscription_id].vnet_resource_group
  virtual_network_name = local.subscription_vnet_map[data.azurerm_subscription.current.subscription_id].vnet_name
  address_prefixes     = each.value.address_prefixes
  service_endpoints    = each.value.service_endpoints
}

resource "azurerm_route_table" "this" {
  for_each                      = var.route_tables
  name                          = "${local.name}-${each.key}-${var.env}"
  resource_group_name           = local.subscription_vnet_map[data.azurerm_subscription.current.subscription_id].vnet_resource_group
  disable_bgp_route_propagation = false
  location                      = var.location
  tags                          = var.common_tags
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
  for_each       = var.route_tables
  subnet_id      = azurerm_subnet.this[each.value.subnet].id
  route_table_id = azurerm_route_table.this[each.key].id
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
  priority                                   = each.value.priority
  direction                                  = each.value.direction
  access                                     = each.value.access
  protocol                                   = each.value.protocol
  source_port_range                          = each.value.source_port_range
  source_port_ranges                         = each.value.source_port_ranges
  destination_port_range                     = each.value.destination_port_range
  destination_port_ranges                    = each.value.destination_port_ranges
  source_address_prefix                      = each.value.source_address_prefix
  source_address_prefixes                    = each.value.source_address_prefixes
  source_application_security_group_ids      = each.value.source_application_security_group_ids
  destination_address_prefix                 = each.value.destination_address_prefix
  destination_address_prefixes               = each.value.destination_address_prefixes
  destination_application_security_group_ids = each.value.destination_application_security_group_ids
  description                                = each.value.description
}

resource "azurerm_subnet_network_security_group_association" "this" {
  for_each                  = { for key, value in var.network_security_groups : key => value if value.subnet != null }
  subnet_id                 = azurerm_subnet.this[each.value.subnet].id
  network_security_group_id = azurerm_network_security_group.this[each.key].id
}

resource "azurerm_storage_account_network_rules" "this" {
  storage_account_id = azurerm_storage_account.this.id

  default_action = "Deny"
  virtual_network_subnet_ids = [
    azurerm_subnet.this.*.id
  ]
  bypass = ["AzureServices"]
}
