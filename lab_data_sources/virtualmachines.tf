resource "azurerm_network_interface" "appinterface" {
  count = var.number_of_machines
  name                = "appinterface${count.index}"
  location            = azurerm_resource_group.appgrp.location
  resource_group_name = azurerm_resource_group.appgrp.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnets[count.index].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.appip[count.index].id
  }
  depends_on = [ 
    azurerm_subnet.subnets, 
    azurerm_public_ip.appip 
  ]
}

resource "azurerm_public_ip" "appip" {
  count               = var.number_of_machines
  name                = "appip${count.index}"
  resource_group_name = azurerm_resource_group.appgrp.name
  location            = local.location
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = [ "${count.index + 1}" ]

  depends_on = [ azurerm_resource_group.appgrp ]
}

data "azurerm_key_vault" "keyvault93012205093" {
  name                = "keyvault93012205093"
  resource_group_name = azurerm_resource_group.appgrp.name
}

data "azurerm_key_vault_secret" "vmpassword" {
  name         = "vmpassword"
  key_vault_id = data.azurerm_key_vault.keyvault93012205093.id
}

resource "azurerm_windows_virtual_machine" "appvm" {
  count = var.number_of_machines
  name                = "appvm${count.index}"
  resource_group_name = azurerm_resource_group.appgrp.name
  location            = azurerm_resource_group.appgrp.location
  size                = "Standard_D2s_v3"
  admin_username      = "adminuser"
  admin_password      = data.azurerm_key_vault_secret.vmpassword.value
  zone = (count.index + 1)
  network_interface_ids = [
    azurerm_network_interface.appinterface[count.index].id,
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
      azurerm_resource_group.appgrp,
      azurerm_network_interface.appinterface
   ]
}