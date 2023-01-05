resource "azurerm_key_vault" "keyvault" {  
  name                        = "keyvault09012000"
  location                    = azurerm_resource_group.rg1.location
  resource_group_name         = azurerm_resource_group.rg1.name  
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name = "standard"
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id
    key_permissions = [
      "get",
    ]
    secret_permissions = [
      "get", "backup", "delete", "list", "purge", "recover", "restore", "set",
    ]
    storage_permissions = [
      "get",
    ]
  }
  depends_on = [
    azurerm_resource_group.rg1
  ]
}

resource "azurerm_key_vault_secret" "vmpassword" {
  name         = "vmpassword"
  value        = "P@$$w0rd1234!"
  key_vault_id = azurerm_key_vault.keyvault.id
  depends_on = [ azurerm_key_vault.keyvault ]
}