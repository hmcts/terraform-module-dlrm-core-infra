output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "resource_group_location" {
  value = azurerm_resource_group.rg.location
}

output "storage_account_name" {
  value = azurerm_storage_account.this.name
}

output "storage_account_id" {
  value = azurerm_storage_account.this.id
}

output "storage_account_key" {
  value = azurerm_storage_account.this.primary_access_key
}

output "subnet_ids" {
  value = { for key, id in module.networking.subnet_ids :
    replace(key, "${local.new_vnet_name}-", "") => id
  }
  description = "Map of subnet name to subnet ID."
}

