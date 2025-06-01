resource "random_integer" "rand" {
  min = 10000
  max = 99999
}

resource "azurerm_resource_group" "rg" {
  name     = "tenant-a-rg"
  location = "eastus"
}

resource "azurerm_storage_account" "storage" {
  name                     = "tenantastorage${random_integer.rand.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

