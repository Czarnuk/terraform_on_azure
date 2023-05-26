resource "azurerm_network_interface" "appinterface" {
  name                = "appinterface"
  location            = local.location
  resource_group_name = local.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnetA.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.appip.id
  }
  depends_on = [ 
    azurerm_virtual_network.appnetwork,
    azurerm_public_ip.appip 
  ]
}

resource "azurerm_public_ip" "appip" {
  name                = "app-ip"
  resource_group_name = local.resource_group_name
  location            = local.location
  allocation_method   = "Static"

  depends_on = [ azurerm_resource_group.appgrp ]
}

resource "azurerm_windows_virtual_machine" "appvm" {
  name                = "appvm"
  resource_group_name = local.resource_group_name
  location            = local.location
  size                = "Standard_D2s_v3"
  admin_username      = "adminuser"
  admin_password      = "Robertos987@"
  network_interface_ids = [
    azurerm_network_interface.appinterface.id
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
      azurerm_virtual_network.appnetwork,
      azurerm_network_interface.appinterface
   ]
}

resource "azurerm_storage_account" "appstore465656" {
  name                     = "appstore465656"
  resource_group_name      = local.resource_group_name
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  depends_on = [ 
    azurerm_resource_group.appgrp
   ]

}

resource "azurerm_storage_container" "data" {
  name                  = "data"
  storage_account_name  = azurerm_storage_account.appstore465656.name
  container_access_type = "blob"

  depends_on = [ 
    azurerm_storage_account.appstore465656
   ]
}

resource "azurerm_storage_blob" "blob" {
  name                   = "IIS_Config.ps1"
  storage_account_name   = azurerm_storage_account.appstore465656.name
  storage_container_name = azurerm_storage_container.data.name
  type                   = "Block"
  source                 = "IIS_Config.ps1"

  depends_on = [ 
    azurerm_storage_container.data
   ]
}