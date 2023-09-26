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

  route_tables            = local.route_tables
  network_security_groups = local.network_security_groups
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
