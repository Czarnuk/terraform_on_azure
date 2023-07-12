resource "azuread_user" "userA" {
  user_principal_name = "userA@robdar987gmail.onmicrosoft.com"
  display_name        = "userA"
  password            = "Robertos987@"
}

resource "azurerm_role_assignment" "Reader_role" {
  scope                = azurerm_resource_group.appgrp.id
  role_definition_name = "Reader"
  principal_id         = azuread_user.userA.object_id

  depends_on = [ 
    azurerm_resource_group.appgrp,
    azuread_user.userA
   ]
}
