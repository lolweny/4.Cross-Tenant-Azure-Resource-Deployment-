provider "azurerm" {
  features {}

  subscription_id = "a2f8755a-9bc3-4ee0-b8c2-9daa7744504b"
  client_id       = "7c7e2bcc-1f24-44c4-bce1-b7a890fe172c"
  client_secret   = var.client_secret
  tenant_id       = "b21ca824-f6ad-4294-9475-7a50b028b6b6"
}

