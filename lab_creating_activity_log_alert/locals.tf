locals {
  resource_group_name = "app-grp"
  location = "North Europe"
  virtual_network = {
    name = "appnetwork",
    address_space = "10.0.0.0/16"
  }
  subnets = [
    {
      name = "subnetA",
      address_prefix = "10.0.0.0/24"
    }
  ]
}