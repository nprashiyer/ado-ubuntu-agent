data "azurerm_resource_group" "agent" {
  name = var.resource_group_name
}

data "azurerm_subnet" "agent" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_rg_name
}