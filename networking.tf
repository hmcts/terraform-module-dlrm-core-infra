module "networking" {
  source = "github.com/hmcts/terraform-module-azure-virtual-networking?ref=main"

  env                          = var.env
  product                      = var.project
  common_tags                  = var.common_tags
  component                    = "networking"
  name                         = local.name
  existing_resource_group_name = local.create_vnet ? azurerm_resource_group.rg.name : local.vnet_config.vnet_resource_group

  vnets = local.create_vnet ? {
    "${local.new_vnet_name}" = {
      existing      = false
      address_space = var.new_vnet.address_space
      subnets       = var.subnets
    }
    } : {
    "${local.vnet_config.vnet_name}" = {
      existing      = true
      address_space = null
      subnets       = var.subnets
    }
  }

  route_tables            = local.route_tables
  network_security_groups = local.network_security_groups
}

module "vnet_peer_hub" {
  count  = local.create_vnet ? 1 : 0
  source = "github.com/hmcts/terraform-module-vnet-peering"
  peerings = {
    source = {
      name           = "${local.name}-vnet-to-hub"
      vnet           = module.networking.vnet_names[local.new_vnet_name]
      resource_group = module.networking.resource_group_name
    }
    target = {
      name           = "${local.name}-hub-to-vnet"
      vnet           = var.hub_vnet_name
      resource_group = var.hub_vnet_resource_group
    }
  }

  providers = {
    azurerm.initiator = azurerm
    azurerm.target    = azurerm.hub
  }
}
