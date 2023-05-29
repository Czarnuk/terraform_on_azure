# $env:TF_LOG="DEBUG" to extend plan stage with details
# $env:TF_LOG_PATH="C:\tmp1\terraform.log" to save log to file

resource "azurerm_resource_group" "appgrp" {
  name     = local.resource_group_name
  location = local.location
}

resource "random_uuid" "storageaccountidentifier" {
  
}

output "randomid" {
  value = substr(random_uuid.storageaccountidentifier.result, 0, 8)
}