resource "azurerm_virtual_network" "vnet1" {
  name                = "vnet-1"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    environment = "testNET"
  }
  depends_on = [
    azurerm_resource_group.rg1
  ]
}

resource "azurerm_subnet" "subnet1" {
  name                 = "example-subnet"
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.0.1.0/24"]
  depends_on = [
    azurerm_virtual_network.vnet1
  ]
}

resource "azurerm_public_ip" "public_ip" {
  name                = "public-ip"
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location
  allocation_method   = "Static"
  depends_on = [
    azurerm_resource_group.rg1
  ]
  
}

