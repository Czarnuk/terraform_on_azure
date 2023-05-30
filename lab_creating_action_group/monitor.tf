resource "azurerm_monitor_action_group" "email_alert" {
  name                = "email_alert"
  resource_group_name = local.resource_group_name
  short_name          = "email_alert"

    email_receiver {
    name                        = "send-email_alert"
    email_address               = "rdaraz@deloittece.com"
    use_common_alert_schema     = true
  }
  depends_on = [ azurerm_resource_group.appgrp ]
}