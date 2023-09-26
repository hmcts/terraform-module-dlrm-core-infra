data "azurerm_subscription" "current" {
}

locals {
  name                   = var.name != "" ? var.name : var.project
  is_prod                = length(regexall(".*(prod).*", var.env)) > 0
  backup_retention_daily = var.backup_retention_daily_count != null ? var.backup_retention_daily_count : local.is_prod ? 28 : 7
  subscription_vnet_map = {
    "ae75b9fb-7d34-4112-82ff-64bd3855ce27" = {
      vnet_name           = "vnet-nle-int-01"
      vnet_resource_group = "InternalSpoke-rg"
      default_route_table = "NLE-INTERNAL-RT"
    }
    "9c604868-4643-43b8-9eb1-4c348c739a3e" = {
      vnet_name           = "vnet-nle-ext-01"
      vnet_resource_group = "ExternalSpoke-rg"
      default_route_table = "NLE-EXTERNAL-RT"
    }
    "17390ec1-5a5e-4a20-afb3-38d8d726ae45" = {
      vnet_name           = "vnet-prod-int-01"
      vnet_resource_group = "InternalSpoke-rg"
      default_route_table = "PROD-INTERNAL-RT"
    }
    "c170c61a-f00f-4295-a718-634e27af1597" = {
      vnet_name           = "vnet-prod-ext-01"
      vnet_resource_group = "ExternalSpoke-rg"
      default_route_table = "PROD-EXTERNAL-RT"
    }
  }
  subnet_ids = flatten([
    for subnet_id in module.networking.subnet_ids : [
      subnet_id
    ]
  ])
}
