#--------------------------------------------------------------------------------------------------
# Azure Integration
#--------------------------------------------------------------------------------------------------
azure_client_id                       = ""  # App registration ID / App ID
azure_client_secret                   = ""  # App registration Secret
azure_tenant_id                       = ""  # Azure Tenant ID
azure_subscription_id                 = ""  # Azure Subscription ID to deploy resources into

#--------------------------------------------------------------------------------------------------
# Default tags
#--------------------------------------------------------------------------------------------------
# These tags are applied to every resource created in this template
default_tags = {
  ContactPerson                       = ""
  Environment                         = ""
  ManagedByTerraform                  = ""
}

#--------------------------------------------------------------------------------------------------
# Resource Group - These will apply to all resource within the deployment
#--------------------------------------------------------------------------------------------------
prefix                                = "" # the prefix for all resources. "test" == appliance named test-va
resource_group_name                   = "" # the resource group to create, and add resources to. everything is added here.
location                              = "" # this template deploys everything to one region, set here.

#--------------------------------------------------------------------------------------------------
# Azure Compute Gallery Image Variables
#--------------------------------------------------------------------------------------------------
appliance_gallery_resource_group      = "" # The resource group where the gallery lives
appliance_gallery_name                = "" # The name of your Shared Image Gallery
appliance_image_name                  = "" # The image definition name in the gallery
appliance_image_version               = "" # The version of the image you want to use (or "latest")

#--------------------------------------------------------------------------------------------------
# Networking
#--------------------------------------------------------------------------------------------------
dns_servers                           = [] # dns servers used by the Virtual Network
vnet_cidr                             = ["10.11.0.0/16"] # vnet CIDR
snet_cidr                             = ["10.11.1.0/24"] # snet CIDR

#--------------------------------------------------------------------------------------------------
# Appliance
#--------------------------------------------------------------------------------------------------
appliance_hostname                    = "" # appliance hostname, different than the azure resource name
appliance_domain_name                 = "" # the expected domain name, either eastus.cloudapp.azure.com or custom domain, e.g. contoso.com
appliance_encoded_password            = "" # the base64 encoded password used to authenticate with root Linux user ('admin')                                                                              
appliance_private_ip                  = "" # the private IP to assign the VM
appliance_storage_account_type        = "" # the storage account type for the virtual appliance VM disk, e.g., Standard_LRS

#--------------------------------------------------------------------------------------------------
# Appliance VM Size
#--------------------------------------------------------------------------------------------------
appliance_instance_type               = "" # Instance Type of the Virtual Appliance
