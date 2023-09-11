data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "this" {
  name                        = "${local.name}-kv-${var.env}"
  resource_group_name         = azurerm_resource_group.rg.name
  location                    = azurerm_resource_group.rg.location
  sku_name                    = "standard"
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled    = true
  enabled_for_disk_encryption = true

  access_policy = [
    {
      tenant_id      = data.azurerm_client_config.current.tenant_id
      object_id      = data.azurerm_client_config.current.object_id
      application_id = null

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
    },
    // Allow DTS Platform Operations to access
    {
      tenant_id      = data.azurerm_client_config.current.tenant_id
      object_id      = "e7ea2042-4ced-45dd-8ae3-e051c6551789"
      application_id = null

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
    },
    // Allow Backup managemnet to access
    {
      tenant_id      = data.azurerm_client_config.current.tenant_id
      object_id      = "de5896d6-6cef-413a-833b-358762739960"
      application_id = null

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
  ]

  tags = var.common_tags
}
