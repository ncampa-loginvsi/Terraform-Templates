#--------------------------------------------------------------------------------------------------
# Virtual Networks
#--------------------------------------------------------------------------------------------------
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-vnet"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = var.vnet_cidr
  dns_servers         = var.dns_servers
  tags                = var.default_tags
}

