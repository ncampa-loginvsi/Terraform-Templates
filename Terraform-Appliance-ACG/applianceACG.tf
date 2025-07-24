#--------------------------------------
# Login Enterprise Virtual Appliance
#--------------------------------------

#-----------------------------------------------
# Locals (This is the azure.yml file, which receives the password and domain_name dynamically)
#-----------------------------------------------
locals {
  custom_data = <<CUSTOM_DATA
  #cloud-config

  # INSTRUCTIONS: upload this file in the Custom Script section when creating a VM
  write_files:
  # Password:
  -   content: |
          ${var.appliance_encoded_password}
      path: /home/admin/.password
  # CAUTION: Base64 encoded password to eliminate parsing errors, this is NOT secure or safe in any way
  # This is merely provided for your convenience
  # We recommend using the default firstrun mechanism instead by logging on to the VM console
  -   content: |
          #Empty file
      path: /loginvsi/first_run.chk
  runcmd:
   - domainname ${var.appliance_domain_name}
   - /loginvsi/bin/firstrun
CUSTOM_DATA
}

#-----------------------------------------------
# Get Image from Azure Compute Gallery
#-----------------------------------------------
data "azurerm_shared_image_version" "virtual_appliance" {
  name                = var.appliance_image_version             
  image_name          = var.appliance_image_name                
  gallery_name        = var.appliance_gallery_name              
  resource_group_name = var.appliance_gallery_resource_group    # resource group containing your ACG
}

#-----------------------------------
# Public IP for Virtual Appliance
#-----------------------------------
# If you do not want a Public IP, or internet-accessible appliance, comment this out.check 
# You will need to use the alternate NIC config, which is commented out below. 
# There are helpful comments there to help you find it.
resource "azurerm_public_ip" "virtual_appliance" {
  name                = "${var.prefix}-va-pip"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = var.appliance_hostname
  tags                = var.default_tags
}

#-----------------------------------
# Create NIC and associate PIP
#-----------------------------------
resource "azurerm_network_interface" "virtual_appliance" {
  name                = "${var.prefix}-va-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "appliance_ip_config"
    primary                       = true
    subnet_id                     = azurerm_subnet.snet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.appliance_private_ip
    public_ip_address_id          = azurerm_public_ip.virtual_appliance.id
  }

  tags = var.default_tags
}

# Comment the above NIC out, and uncomment this for no Public IP assignment.
# The only difference is that public_ip_address_id is removed.
/*
resource "azurerm_network_interface" "virtual_appliance" {
  name                = "${var.prefix}-va-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "appliance_ip_config"
    primary                       = true
    subnet_id                     = azurerm_subnet.snet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.appliance_private_ip
  }

  tags = var.default_tags
}
*/

#-----------------------------------------------
# Create Virtual Machine from ACG Image
#-----------------------------------------------
resource "azurerm_linux_virtual_machine" "virtual_appliance" {
  name                = "${var.prefix}-va"
  computer_name       = var.appliance_hostname
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  size                = var.appliance_instance_type
  tags                = var.default_tags

  network_interface_ids = [azurerm_network_interface.virtual_appliance.id]
  source_image_id       = data.azurerm_shared_image_version.virtual_appliance.id

  # Set Credentials
  admin_username                  = "secretUsername" # not used by the appliance; dummy values are fine
  admin_password                  = "mySecretPassword123!"
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.appliance_storage_account_type
    disk_size_gb         = 128 # Ensure OS disk is >= 100GB
  }

  # boot_diagnostics {
#     storage_account_uri = var.storage_account_uri
#   }

  provision_vm_agent = true
  custom_data        = base64encode(local.custom_data)
}

#---------------------------------------
# Get Public IP
#---------------------------------------
data "azurerm_public_ip" "virtual_appliance_data" {
  name                = azurerm_public_ip.virtual_appliance.name
  resource_group_name = azurerm_resource_group.rg.name
}

output "public_ip_address_appliance" {
  value = data.azurerm_public_ip.virtual_appliance_data.ip_address
}
