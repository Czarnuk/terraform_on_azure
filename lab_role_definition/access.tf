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

data "azurerm_subscription" "Azuresubscription" {
}

resource "azurerm_role_definition" "customrole" {
  name        = "Customrole"
  scope       = data.azurerm_subscription.Azuresubscription.id
  description = "This is a custom role created via Terraform"

  permissions {
    actions     = [                    
      "Microsoft.Compute/virtualMachines/start/action",
      "Microsoft.Compute/virtualMachines/restart/action",
      "Microsoft.Compute/virtualMachines/read"
    ]
    not_actions = []
  }

  assignable_scopes = [
    data.azurerm_subscription.Azuresubscription.id,
  ]
}

resource "azurerm_role_assignment" "Custom_role_assignment" {
  scope                = azurerm_resource_group.appgrp.id
  role_definition_name = "Customrole"
  principal_id         = azuread_user.userA.object_id

  depends_on = [ 
    azurerm_resource_group.appgrp,
    azuread_user.userA,
    azurerm_role_definition.customrole
   ]
}