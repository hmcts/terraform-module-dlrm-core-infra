variable "existing_resource_group_name" {
  description = "Name of existing resource group to deploy resources into"
  type        = string
  default     = null
}

variable "location" {
  description = "Target Azure location to deploy the resource"
  type        = string
  default     = "UK South"
}

variable "name" {
  type        = string
  default     = ""
  description = "The default name will be product+component+env, you can override the product+component part by setting this"
}

variable "recovery_services_sku" {
  type        = string
  description = "The SKU of the Recovery Services Vault."
  default     = "Standard"
}

variable "backup_policy_frequency" {
  type        = string
  description = "The Frequency of the Backup Policy."
  default     = "Daily"
}

variable "backup_policy_time" {
  type        = string
  description = "The Time of the Backup Policy."
  default     = "01:00"
}

variable "backup_retention_daily_count" {
  type        = number
  description = "The Daily Retention Count."
  default     = 10
}

variable "backup_retention_monthly_count" {
  type        = number
  description = "The monthly retention count."
  default     = 12
}

variable "backup_retention_monthly_weekdays" {
  type        = list(string)
  description = "The day backups to retain on a monthly basis."
  default     = ["Sunday", "Wednesday"]
}

variable "backup_retention_monthly_weeks" {
  type        = list(string)
  description = "The week backups to retain on a monthly basis."
  default     = ["First", "Last"]
}

variable "backup_retention_yearly_count" {
  type        = number
  description = "The yearly retention count."
  default     = 1
}

variable "backup_retention_yearly_weekdays" {
  type        = list(string)
  description = "The day backups to retain on a yearly basis."
  default     = ["Sunday"]
}

variable "backup_retention_yearly_weeks" {
  type        = list(string)
  description = "The week backups to retain on a yearly basis."
  default     = ["Last"]
}

variable "backup_retention_yearly_months" {
  type        = list(string)
  description = "The month backups to retain on a yearly basis."
  default     = ["January"]
}

variable "instant_restore_retention_days" {
  type        = number
  description = "The instance restore retention days."
  default     = 1
}
