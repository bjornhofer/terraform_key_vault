provider "azurerm" {
  features {}
  alias           = "key_vault"
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

data "azurerm_client_config" "current" {
  provider = azurerm.key_vault
}

data "azurerm_resource_group" "resource_group" {
  name     = var.resource_group_name
  provider = azurerm.key_vault
}

locals {
  key_vault_name = length(var.key_vault_name_suffix) > 0 ? "${var.key_vault_name_prefix}-${var.key_vault_base_name}-${var.key_vault_name_suffix}" : "${var.key_vault_name_prefix}-${var.key_vault_base_name}"
}

resource "azurerm_key_vault" "key_vault" {
  name                          = local.key_vault_name
  location                      = data.azurerm_resource_group.resource_group.location
  resource_group_name           = data.azurerm_resource_group.resource_group.name
  enabled_for_disk_encryption   = var.enabled_for_disk_encryption
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days    = var.soft_delete_retention_days
  purge_protection_enabled      = var.purge_protection_enabled
  public_network_access_enabled = var.public_network_access_enabled

  sku_name = var.key_vault_sku_name

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
    ]

    storage_permissions = [
      "Get",
    ]
  }
  provider = azurerm.key_vault
}

resource "azurerm_key_vault_access_policy" "access_policies" {
  for_each            = { for policy in var.access_policies : policy.object_id => policy }
  key_vault_id        = azurerm_key_vault.key_vault.id
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = each.key
  key_permissions     = each.value.key_permissions
  secret_permissions  = each.value.secret_permissions
  storage_permissions = each.value.storage_permissions
  provider            = azurerm.key_vault
}
