resource "random_integer" "rand" {
  min = 10000
  max = 99999
}

# 🏗️ Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "tenant-b-rg"
  location = "eastus"
}

# 💾 Storage Account
resource "azurerm_storage_account" "storage" {
  name                     = "tenantbstorage${random_integer.rand.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# 📊 Log Analytics Workspace (optional, no diagnostics configured)
resource "azurerm_log_analytics_workspace" "logs" {
  name                = "tenantb-log-workspace"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# 🔐 Azure Key Vault with Access Policy for SP
resource "azurerm_key_vault" "kv" {
  name                        = "tenantb-kv-${random_integer.rand.result}"
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  tenant_id                   = "f30b55b1-c7e1-4871-80b1-c2fa47512900"  # Tenant B
  sku_name                    = "standard"
  soft_delete_retention_days  = 7
  purge_protection_enabled    = true

  access_policy {
    tenant_id = "f30b55b1-c7e1-4871-80b1-c2fa47512900"
    object_id = "47c325db-5c4a-4c35-b65f-c3295c2281a5"  # SP object ID from error message

    secret_permissions = [
      "Get",
      "List",
      "Set"
    ]
  }
}

# 🔑 Key Vault Secret
resource "azurerm_key_vault_secret" "example" {
  name         = "exampleSecret"
  value        = "SuperSecretValue123"
  key_vault_id = azurerm_key_vault.kv.id
}

