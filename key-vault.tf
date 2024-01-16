data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "this" {
  name                        = "${local.name}-kv-${var.env}"
  resource_group_name         = azurerm_resource_group.rg.name
  location                    = azurerm_resource_group.rg.location
  sku_name                    = "standard"
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled    = true
  enabled_for_disk_encryption = true
  tags                        = var.common_tags
}

resource "azurerm_key_vault_access_policy" "this" {
  for_each     = local.key_vault_access_policies
  key_vault_id = azurerm_key_vault.this.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = each.key

  certificate_permissions = each.value.certificate_permissions
  key_permissions         = each.value.key_permissions
  storage_permissions     = each.value.storage_permissions
  secret_permissions      = each.value.secret_permissions
}
