#--------------------------------------------------------------------------------------------------
# Subnet
#--------------------------------------------------------------------------------------------------
resource "azurerm_subnet" "snet" {
  name                 = "${var.prefix}-snet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.snet_cidr
}