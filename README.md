# terraform-module-dlrm-core-infra

Terraform module to deploy "core" resource used by DLRM projects, these often include Key Vaults, RSV, Subnet(s), NSGs, Route Tables.

## Example

```hcl
module "core-infra" {
  source = "git::https://github.com/hmcts/terraform-module-dlrm-core-infra.git?ref=main"
  env    = "sbox"
  common_tags = {
    "product"   = "dlrm"
    "component" = "core"
  }
  project = "dlrm-project-a"
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 3.71.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.71.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_backup_policy_vm.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.71.0/docs/resources/backup_policy_vm) | resource |
| [azurerm_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.71.0/docs/resources/key_vault) | resource |
| [azurerm_network_security_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.71.0/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.rules](https://registry.terraform.io/providers/hashicorp/azurerm/3.71.0/docs/resources/network_security_rule) | resource |
| [azurerm_recovery_services_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.71.0/docs/resources/recovery_services_vault) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/3.71.0/docs/resources/resource_group) | resource |
| [azurerm_route_table.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.71.0/docs/resources/route_table) | resource |
| [azurerm_storage_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.71.0/docs/resources/storage_account) | resource |
| [azurerm_storage_account_network_rules.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.71.0/docs/resources/storage_account_network_rules) | resource |
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.71.0/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.71.0/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_route_table_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.71.0/docs/resources/subnet_route_table_association) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/3.71.0/docs/data-sources/client_config) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/3.71.0/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_policy_frequency"></a> [backup\_policy\_frequency](#input\_backup\_policy\_frequency) | The Frequency of the Backup Policy. | `string` | `"Daily"` | no |
| <a name="input_backup_policy_time"></a> [backup\_policy\_time](#input\_backup\_policy\_time) | The Time of the Backup Policy. | `string` | `"01:00"` | no |
| <a name="input_backup_retention_daily_count"></a> [backup\_retention\_daily\_count](#input\_backup\_retention\_daily\_count) | The Daily Retention Count. | `number` | `10` | no |
| <a name="input_backup_retention_monthly_count"></a> [backup\_retention\_monthly\_count](#input\_backup\_retention\_monthly\_count) | The monthly retention count. | `number` | `12` | no |
| <a name="input_backup_retention_monthly_weekdays"></a> [backup\_retention\_monthly\_weekdays](#input\_backup\_retention\_monthly\_weekdays) | The day backups to retain on a monthly basis. | `list(string)` | <pre>[<br>  "Sunday",<br>  "Wednesday"<br>]</pre> | no |
| <a name="input_backup_retention_monthly_weeks"></a> [backup\_retention\_monthly\_weeks](#input\_backup\_retention\_monthly\_weeks) | The week backups to retain on a monthly basis. | `list(string)` | <pre>[<br>  "First",<br>  "Last"<br>]</pre> | no |
| <a name="input_backup_retention_yearly_count"></a> [backup\_retention\_yearly\_count](#input\_backup\_retention\_yearly\_count) | The yearly retention count. | `number` | `1` | no |
| <a name="input_backup_retention_yearly_months"></a> [backup\_retention\_yearly\_months](#input\_backup\_retention\_yearly\_months) | The month backups to retain on a yearly basis. | `list(string)` | <pre>[<br>  "January"<br>]</pre> | no |
| <a name="input_backup_retention_yearly_weekdays"></a> [backup\_retention\_yearly\_weekdays](#input\_backup\_retention\_yearly\_weekdays) | The day backups to retain on a yearly basis. | `list(string)` | <pre>[<br>  "Sunday"<br>]</pre> | no |
| <a name="input_backup_retention_yearly_weeks"></a> [backup\_retention\_yearly\_weeks](#input\_backup\_retention\_yearly\_weeks) | The week backups to retain on a yearly basis. | `list(string)` | <pre>[<br>  "Last"<br>]</pre> | no |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | Common tag to be applied to resources | `map(string)` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | Environment value | `string` | n/a | yes |
| <a name="input_existing_resource_group_name"></a> [existing\_resource\_group\_name](#input\_existing\_resource\_group\_name) | Name of existing resource group to deploy resources into | `string` | `null` | no |
| <a name="input_instant_restore_retention_days"></a> [instant\_restore\_retention\_days](#input\_instant\_restore\_retention\_days) | The instance restore retention days. | `number` | `1` | no |
| <a name="input_location"></a> [location](#input\_location) | Target Azure location to deploy the resource | `string` | `"UK South"` | no |
| <a name="input_name"></a> [name](#input\_name) | The default name will be product+component+env, you can override the product+component part by setting this | `string` | `""` | no |
| <a name="input_network_security_groups"></a> [network\_security\_groups](#input\_network\_security\_groups) | n/a | <pre>map(object({<br>    subnet = optional(string, null)<br>    rules = map(object({<br>      priority                                   = number,<br>      direction                                  = string,<br>      access                                     = string,<br>      protocol                                   = string,<br>      source_port_range                          = optional(string, null)<br>      source_port_ranges                         = optional(list(string), null)<br>      destination_port_range                     = optional(string, null)<br>      destination_port_ranges                    = optional(list(string), null)<br>      source_address_prefix                      = optional(string, null)<br>      source_address_prefixes                    = optional(list(string), null)<br>      source_application_security_group_ids      = optional(list(string), null)<br>      destination_address_prefix                 = optional(string, null)<br>      destination_address_prefixes               = optional(list(string), null)<br>      destination_application_security_group_ids = optional(list(string), null)<br>      description                                = optional(string, null)<br>    }))<br>  }))</pre> | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | The name of the DLRM project, this will feature in resource names. | `string` | n/a | yes |
| <a name="input_recovery_services_sku"></a> [recovery\_services\_sku](#input\_recovery\_services\_sku) | The SKU of the Recovery Services Vault. | `string` | `"Standard"` | no |
| <a name="input_route_tables"></a> [route\_tables](#input\_route\_tables) | n/a | `map(object({ subnet = string, routes = list(object({ name = string, address_prefix = string, next_hop_type = string })) }))` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Map of subnets to create. | `map(object({ address_prefixes = list(string), service_endpoints = optional(list(string), []) }))` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_resource_group_location"></a> [resource\_group\_location](#output\_resource\_group\_location) | n/a |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | n/a |
<!-- END_TF_DOCS -->

## Contributing

We use pre-commit hooks for validating the terraform format and maintaining the documentation automatically.
Install it with:

```shell
$ brew install pre-commit terraform-docs
$ pre-commit install
```

If you add a new hook make sure to run it against all files:
```shell
$ pre-commit run --all-files
```
