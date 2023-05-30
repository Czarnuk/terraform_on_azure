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

resource "azurerm_monitor_metric_alert" "Network_threshold_alert" {
  name                = "Network-threshold-alert"
  resource_group_name = local.resource_group_name
  scopes              = [azurerm_windows_virtual_machine.appvm.id]
  description         = "The alert will be sent if the Network Out bytes exceeds 70 bytes"

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Network Out Total"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 70

  }

  action {
    action_group_id = azurerm_monitor_action_group.email_alert.id
  }

  depends_on = [ 
    azurerm_windows_virtual_machine.appvm, azurerm_monitor_action_group.email_alert ]
}