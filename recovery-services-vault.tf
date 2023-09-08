resource "azurerm_recovery_services_vault" "this" {
  name                         = "${local.name}-rsv-${var.env}"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  sku                          = var.recovery_services_sku
  storage_mode_type            = "GeoRedundant"
  cross_region_restore_enabled = true
  tags                         = var.common_tags
}

resource "azurerm_backup_policy_vm" "this" {
  name                = "${local.name}-daily-bp-${var.env}"
  resource_group_name = azurerm_resource_group.rg.name
  recovery_vault_name = azurerm_recovery_services_vault.this.name

  timezone                       = "UTC"
  policy_type                    = "V2"
  instant_restore_retention_days = var.instant_restore_retention_days

  backup {
    frequency = var.backup_policy_frequency
    time      = var.backup_policy_time
  }

  retention_daily {
    count = var.backup_retention_daily_count
  }

  retention_monthly {
    count    = var.backup_retention_monthly_count
    weekdays = var.backup_retention_monthly_weekdays
    weeks    = var.backup_retention_monthly_weeks
  }

  retention_yearly {
    count    = var.backup_retention_yearly_count
    months   = var.backup_retention_yearly_months
    weeks    = var.backup_retention_yearly_weeks
    weekdays = var.backup_retention_yearly_weekdays
  }
}
