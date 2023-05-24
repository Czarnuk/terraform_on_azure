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
  client_secret = "ijs8Q~uJdq2-2xUe-FhekBPDf2ezP8ForbRXuacs"
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
}