#--------------------------------------------------------------------------------------------------
# Resource Group
#--------------------------------------------------------------------------------------------------
resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-${var.resource_group_name}"
  location = var.location
  tags     = var.default_tags
}