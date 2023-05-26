resource "azurerm_storage_account" "appstore465657" {
  name                     = "appstore465657"
  resource_group_name      = local.resource_group_name
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  network_rules {
    default_action             = "Deny"
    ip_rules                   = ["185.153.39.24"]
    virtual_network_subnet_ids = [azurerm_subnet.subnetA.id]
  }

  depends_on = [ 
    azurerm_resource_group.appgrp,
    azurerm_subnet.subnetA
   ]

}

resource "azurerm_storage_container" "data1" {
  name                  = "data1"
  storage_account_name  = azurerm_storage_account.appstore465657.name
  container_access_type = "blob"

  depends_on = [
    azurerm_storage_account.appstore465657
   ]
}

resource "azurerm_storage_blob" "blob1" {
  name                   = "IIS_Config.ps1"
  storage_account_name   = azurerm_storage_account.appstore465657.name
  storage_container_name = azurerm_storage_container.data1.name
  type                   = "Block"
  source                 = "IIS_Config.ps1"

  depends_on = [ 
    azurerm_storage_container.data1
   ]
}