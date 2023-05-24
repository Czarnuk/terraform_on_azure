 terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.55.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "f334b1e3-7197-4f45-a7ea-e5adb1fe7124"
  tenant_id = "716cc674-bec2-49f9-b7bb-0fab84ec8a50"
  client_id = "326eaf16-ba1d-4ea2-ad6a-08b8b006bbc0"
  client_secret = "ELq8Q~yFe6s4Elw~4_mYmgkwMK2Mq8KCjs~TaaXE"
  features {}
}

resource "azurerm_resource_group" "appgrp" {
  name     = "app-grp"
  location = "North Europe"
}

resource "azurerm_storage_account" "appstorerd1" {
  name                     = "appstorerd1"
  resource_group_name      = "app-grp"
  location                 = "North Europe"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind = "StorageV2"
  depends_on = [ azurerm_resource_group.appgrp ]
}

resource "azurerm_storage_container" "data" {
  name                  = "data"
  storage_account_name  = "appstorerd1"
  container_access_type = "blob"
  depends_on = [ azurerm_storage_account.appstorerd1 ]
}

resource "azurerm_storage_blob" "maintf" {
  name                   = "main.tf"
  storage_account_name   = "appstorerd1"
  storage_container_name = "data"
  type                   = "Block"
  source                 = "main.tf"
  depends_on = [ azurerm_storage_container.data ]
}