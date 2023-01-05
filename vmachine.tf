resource "azurerm_network_interface" "vm1_interface" {
  name                = "vm1-interface"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }
  depends_on = [
    azurerm_virtual_network.vnet1,
    azurerm_subnet.subnet1,
    azurerm_public_ip.public_ip
  ]
}

resource "azurerm_windows_virtual_machine" "vm1" {
  name                = "vm1"
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location
  size                = "Standard_D2s_v3"
  admin_username      = "adminuser"
  admin_password      = azurerm_key_vault_secret.vmpassword.value
  availability_set_id = azurerm_availability_set.aset1.id
  network_interface_ids = [
    azurerm_network_interface.vm1_interface.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  depends_on = [
    azurerm_network_interface.vm1_interface,
    azurerm_availability_set.aset1,
    azurerm_key_vault_secret.vmpassword
  ]
}

resource "azurerm_virtual_machine_data_disk_attachment" "disk_attach1" {
  managed_disk_id    = azurerm_managed_disk.mdisk1.id
  virtual_machine_id = azurerm_windows_virtual_machine.vm1.id
  lun                = "10"
  caching            = "ReadWrite"
  depends_on = [
    azurerm_windows_virtual_machine.vm1,
    azurerm_managed_disk.mdisk1
  ]
}


resource "azurerm_virtual_machine_extension" "vm1_extension" {
  name                 = "vm1-extension"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm1.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"
  depends_on = [
    azurerm_storage_blob.IISconfig
  ]
  settings = <<SETTINGS
    {
        "fileUris": ["https://${azurerm_storage_account.stacc1.name}.blob.core.windows.net/data/IISconfig.ps1"],
          "commandToExecute": "powershell -ExecutionPolicy Unrestricted -file IISconfig.ps1"     
    }
SETTINGS

}