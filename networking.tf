module "networking" {
  source = "github.com/hmcts/terraform-module-azure-virtual-networking?ref=main"

  env         = var.env
  product     = var.project
  common_tags = var.common_tags
  component   = "networking"
  name        = local.name

  vnets = {
    "${local.subscription_vnet_map[data.azurerm_subscription.current.subscription_id].vnet_name}" = {
      existing = true
      subnets  = var.subnets
    }
  }

  route_tables            = var.route_tables
  network_security_groups = var.network_security_groups
}
