provider "azurerm" {
  features {}

  subscription_id = "0c3ba492-ed77-4637-ba08-f5b189d8a845"
  client_id       = "75faf311-4ca1-4d9c-9791-8daee7394470"
  client_secret   = var.client_secret
  tenant_id       = "f30b55b1-c7e1-4871-80b1-c2fa47512900"
}

