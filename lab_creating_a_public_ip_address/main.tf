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
  virtual_network = {
    name = "app-network"
    address_space = "10.0.0.0/16"
  }
  subnets = [
    {
      name = "subnetA"
      address_prefix = "10.0.0.0/24"
    },
    {
      name = "subnetB"
      address_prefix = "10.0.1.0/24"
    }
  ]
}

resource "azurerm_resource_group" "appgrp" {
  name     = local.resource_group_name
  location = local.location
}

resource "azurerm_virtual_network" "appnetwork" {
  name                = local.virtual_network.name
  location            = local.location
  resource_group_name = local.resource_group_name
  address_space       = [ local.virtual_network.address_space ]
  
  subnet {
    name = local.subnets[0].name
    address_prefix = local.subnets[0].address_prefix
  }

  subnet {
    name = local.subnets[1].name
    address_prefix = local.subnets[1].address_prefix
  }

  depends_on = [ azurerm_resource_group.appgrp ]
}

resource "azurerm_network_interface" "appinterface" {
  name                = "appinterface"
  location            = local.location
  resource_group_name = local.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = tolist(azurerm_virtual_network.appnetwork.subnet)[0].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.appip.id
  }

  depends_on = [ azurerm_virtual_network.appnetwork ]
}

resource "azurerm_public_ip" "appip" {
  name                = "app-ip"
  resource_group_name = azurerm_resource_group.appgrp.name
  location            = azurerm_resource_group.appgrp.location
  allocation_method   = "Static"

  depends_on = [ azurerm_resource_group.appgrp ]
}