# $env:TF_LOG="DEBUG" to extend plan stage with details
# $env:TF_LOG_PATH="C:\tmp1\terraform.log" to save log to file
# terraform graph | dot -Tsvg > graph.svg - to generat svg graph file

resource "azurerm_resource_group" "appgrp" {
  name     = local.resource_group_name
  location = local.location
}