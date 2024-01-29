resource "azurerm_storage_account" "this" {
  name                     = replace("${local.name}sa${var.env}", "-", "")
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.common_tags
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
