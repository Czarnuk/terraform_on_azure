 terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.56.0"
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

locals {
  resource_group_name = "app-grp"
  location = "North Europe"
}

resource "azurerm_resource_group" "appgrp" {
  name     = local.resource_group_name
  location = local.location
  number_of_virtual_network = 1
}

resource "azurerm_virtual_network" "appnetwork" {
  name                = "app-network"
  location            = local.location
  resource_group_name = local.resource_group_name
  address_space       = ["10.0.0.0/16"]

  subnet {
    name           = "subnetA"
    address_prefix = "10.0.0.0/24"
  }

  subnet {
    name           = "subnetB"
    address_prefix = "10.0.1.0/24"
  }

  depends_on = [ azurerm_resource_group.appgrp ]
}