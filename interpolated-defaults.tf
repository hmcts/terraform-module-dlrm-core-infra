data "azurerm_subscription" "current" {
}

locals {
  name    = var.name != "" ? var.name : var.project
  is_prod = length(regexall(".*(prod).*", var.env)) > 0
  subscription_vnet_map = {
    "ae75b9fb-7d34-4112-82ff-64bd3855ce27" = {
      vnet_name           = "vnet-nle-int-01"
      vnet_resource_group = "InternalSpoke-rg"
    }
    "9c604868-4643-43b8-9eb1-4c348c739a3e" = {
      vnet_name           = "vnet-nle-ext-01"
      vnet_resource_group = "ExternalSpoke-rg"
    }
    "17390ec1-5a5e-4a20-afb3-38d8d726ae45" = {
      vnet_name           = "vnet-prod-int-01"
      vnet_resource_group = "InternalSpoke-rg"
    }
    "c170c61a-f00f-4295-a718-634e27af1597" = {
      vnet_name           = "vnet-prod-ext-01"
      vnet_resource_group = "ExternalSpoke-rg"
    }
  }
  flattened_routes = flatten([
    for route_table_key, route_table in var.route_tables : [
      for route_key, route in route_table.routes : {
        route_table_key = route_table_key
        route_key       = route_key
        route           = route
      }
    ]
  ])
  flattened_nsg_rules = flatten([
    for nsg_key, nsg in var.network_security_groups : [
      for rule_key, rule in nsg.rules : {
        nsg_key  = nsg_key
        rule_key = rule_key
        rule     = rule
      }
    ]
  ])
  subnet_ids = flatten([
    for subnet_key, subnet in var.subnets : [
      azurerm_subnet.this[subnet_key].id
    ]
  ])
}
