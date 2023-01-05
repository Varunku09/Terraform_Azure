resource "azurerm_storage_account" "stacc1" {
  name                     = "stacc1"
  resource_group_name      = azurerm_resource_group.rg1.name
  location                 = azurerm_resource_group.rg1.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_blob_public_access = true
  
}

resource "azurerm_storage_container" "stcon1" {
  name                  = "stcon1"
  storage_account_name  = azurerm_storage_account.stacc1.name
  container_access_type = "public"

  depends_on = [
    azurerm_storage_account.stacc1
  ]
}

resource "azurerm_storage_blob" "IISconfig" {
  name                   = "IISconfig.ps1"
  storage_account_name   = azurerm_storage_account.stacc1.name
  storage_container_name = azurerm_storage_container.stcon1.name
  type                   = "data"
  source                 = "IISconfig.ps1"
  depends_on = [
    azurerm_storage_container.stcon1
  ]
}