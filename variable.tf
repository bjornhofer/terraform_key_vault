// Provider specific settings
variable "subscription_id" {
  type = string
}

variable "client_id" {
  type = string
}

variable "client_secret" {
  type = string
}

variable "tenant_id" {
  type = string
}

// Base Information
variable "key_vault_base_name" {
  description = "Base name for all resources"
  type        = string
}

variable "key_vault_name_prefix" {
  description = "Prefix for all resources"
  type        = string
  default     = "kv"
}

variable "key_vault_name_suffix" {
  description = "Suffix for all resources"
  type        = string
  default     = ""
}

variable "resource_group_name" {
  description = "value of the resource group name"
  type        = string
}

variable "tags" {
  type        = map(string)
  description = "Tags to be applied to all resources"
  default     = {}
}

// KeyVault
variable "key_vault_sku_name" {
  description = "SKU name for the Key Vault"
  type        = string
  default     = "standard"
}

variable "enabled_for_disk_encryption" {
  description = "Enable Key Vault for disk encryption"
  type        = bool
  default     = true
}

variable "soft_delete_retention_days" {
  description = "Soft delete retention days"
  type        = number
  default     = 7
}

variable "purge_protection_enabled" {
  description = "Purge protection enabled"
  type        = bool
  default     = false
}

variable "public_network_access_enabled" {
  description = "Public network access enabled"
  type        = bool
  default     = true
}

variable "access_policies" {
  description = "Access policies for the Key Vault"
  type = list(object({
    object_id           = string
    key_permissions     = list(string)
    secret_permissions  = list(string)
    storage_permissions = list(string)
  }))
  default = []
}

