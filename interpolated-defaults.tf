data "azurerm_subscription" "current" {
}

locals {
  name    = var.name != "" ? var.name : var.project
  is_prod = length(regexall(".*(prod).*", var.env)) > 0
}
