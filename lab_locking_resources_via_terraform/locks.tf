resource "azurerm_management_lock" "appvmlock" {
  name       = "appvmlock"
  scope      = azurerm_windows_virtual_machine.appvm.id
  lock_level = "ReadOnly"
  notes      = "No changes can be made to the virtual machine"
}