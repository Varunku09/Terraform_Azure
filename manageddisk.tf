resource "azurerm_managed_disk" "mdisk1" {
  name                 = "mdisk1"
  location             = azurerm_resource_group.rg1.location
  resource_group_name  = azurerm_resource_group.rg1.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1"

  depends_on = [
    azurerm_resource_group.rg1
  ]
}