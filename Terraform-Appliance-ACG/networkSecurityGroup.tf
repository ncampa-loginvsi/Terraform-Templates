#--------------------------------------------------------------------------------------------------
# Network Security Groups and Rules
#--------------------------------------------------------------------------------------------------
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.prefix}-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.default_tags
}

#--------------------------------------------------------------------------------------------------
# Network Security Group Associations to Subnets
#--------------------------------------------------------------------------------------------------
resource "azurerm_subnet_network_security_group_association" "vnet_snet" {
  subnet_id                 = azurerm_subnet.snet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
