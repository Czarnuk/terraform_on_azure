resource "azurerm_storage_account" "appstore93012205093" {
  name                     = "appstore93012205093"
  resource_group_name      = local.resource_group_name
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind = "StorageV2"
  depends_on = [ 
    azurerm_resource_group.appgrp
  ]
  tags = {
    for name, value in local.common_tags : name => "${value}"
  }
}