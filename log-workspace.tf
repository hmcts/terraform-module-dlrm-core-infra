resource "azurerm_log_analytics_workspace" "this" {
  name                = "${local.name}-law-${var.env}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = var.log_analytics_workspaces.retention_in_days
  daily_quota_gb      = var.log_analytics_workspaces.daily_quota_gb
}
