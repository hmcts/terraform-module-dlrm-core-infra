data "azurerm_subscription" "current" {
}

locals {
  name                      = var.name != "" ? var.name : var.project
  is_prod                   = length(regexall(".*(prod).*", var.env)) > 0
  backup_retention_daily    = var.backup_retention_daily_count != null ? var.backup_retention_daily_count : local.is_prod ? 28 : 7
  ssptl_vnet_name           = "ss-ptl-vnet"
  ssptl_vnet_resource_group = "ss-ptl-network-rg"
  subscription_vnet_map = {
    "d24c931e-2e6d-4508-8583-85ac42715580" = {
      vnet_name           = "vnet-dev-int-01"
      vnet_resource_group = "InternalSpoke-rg"
      default_route_table = "DEV-INTERNAL-RT"
    }
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
  prefixed_subnets = {
    for key, value in var.subnets : "${local.subscription_vnet_map[data.azurerm_subscription.current.subscription_id].vnet_name}-${key}" => value
  }
  route_tables = {
    for key, value in var.route_tables : key => {
      routes  = value.routes
      subnets = [for subnet in value.subnets : "${local.subscription_vnet_map[data.azurerm_subscription.current.subscription_id].vnet_name}-${subnet}"]
    }
  }
  network_security_groups = {
    for key, value in var.network_security_groups : key => {
      subnets      = [for subnet in value.subnets : "${local.subscription_vnet_map[data.azurerm_subscription.current.subscription_id].vnet_name}-${subnet}"]
      deny_inbound = value.deny_inbound
      rules        = value.rules
    }
  }
  subnet_ids = flatten([
    for subnet_id in module.networking.subnet_ids : [
      subnet_id
    ]
  ])

  key_vault_access_policies = merge(local.default_key_vault_access_policies, var.additional_key_vault_policies)
  default_key_vault_access_policies = {
    "${data.azurerm_client_config.current.object_id}" = {
      certificate_permissions = []
      key_permissions = [
        "Get",
        "List",
        "Update",
        "Create",
        "Delete",
        "GetRotationPolicy",
        "Recover",
        "Restore",
        "Purge"
      ]
      storage_permissions = []
      secret_permissions = [
        "Get",
        "List",
        "Set",
        "Delete",
        "Purge",
        "Recover",
        "Restore",
        "Purge"
      ]
    }
    // Allow DTS Platform Operations
    "e7ea2042-4ced-45dd-8ae3-e051c6551789" = {
      certificate_permissions = []
      key_permissions = [
        "Get",
        "List",
        "Update",
        "Create",
        "Delete"
      ]
      storage_permissions = []
      secret_permissions = [
        "Get",
        "List",
        "Set",
        "Delete",
        "Purge"
      ]
    }
    // Allow Backup management
    "de5896d6-6cef-413a-833b-358762739960" = {
      certificate_permissions = []
      key_permissions = [
        "Get",
        "List",
        "Backup"
      ]
      storage_permissions = []
      secret_permissions = [
        "Get",
        "List",
        "Backup"
      ]
    }
  }
}

data "azurerm_subnet" "ssptl-00" {
  provider             = azurerm.ssptl
  name                 = "aks-00"
  virtual_network_name = local.ssptl_vnet_name
  resource_group_name  = local.ssptl_vnet_resource_group
}

data "azurerm_subnet" "ssptl-01" {
  provider             = azurerm.ssptl
  name                 = "aks-01"
  virtual_network_name = local.ssptl_vnet_name
  resource_group_name  = local.ssptl_vnet_resource_group
}
