#--------------------------------------------------------------------------------------------------
# Naming Conventions
#--------------------------------------------------------------------------------------------------
variable "prefix" {
  description = "prefix to all resource names"

}
variable "default_tags" {
  type        = map(any)
  description = "Standard tags to apply to resource group children"
}

#--------------------------------------------------------------------------------------------------
# Azure Subscription
#--------------------------------------------------------------------------------------------------
variable "azure_client_id" {
  description = "The Azure App registration ID assigned to Terraform Provider"
}

variable "azure_client_secret" {
  description = "The Azure App registration Secret assigned to Terraform Provider"
}

variable "azure_tenant_id" {
  description = "The Azure Tenant ID where resources will be deployed"
}

variable "azure_subscription_id" {
  description = "The Azure subscription ID where resources will be deployed"
}

#--------------------------------------------------------------------------------------------------
# Resource Group
#--------------------------------------------------------------------------------------------------
variable "resource_group_name" {
  description = "name of resource group for all resources"
}
variable "location" {
  description = "Azure region to deploy resources into"
}

variable "regions_list" {
  description = "Regions to deploy into"
  default     = ["eastus", "centralus", "westus"]
}


#--------------------------------------------------------------------------------------------------
# Virtual Network
#--------------------------------------------------------------------------------------------------
variable "vnet_cidr" {
  description = "CIDR to use for Virtual Network"
}

#--------------------------------------------------------------------------------------------------
# Subnet
#--------------------------------------------------------------------------------------------------
variable "snet_cidr" {
  description = "CIDR to use for Subnet"
}

#--------------------------------------------------------------------------------------------------
# DNS
#--------------------------------------------------------------------------------------------------
variable "dns_servers" {
  description = "IPs to use as DNS server"
}

#--------------------------------------------------------------------------------------------------
# Appliance
#-------------------------------------------------------------------------------------------------- 
variable "appliance_hostname" {
  description = "Hostname of the Login Enterprise virtual appliance."
}

variable "appliance_encoded_password" {
  description = "Encrypted password of the Login Enterprise virtual appliance."
}

variable "appliance_domain_name" {
  description = "Encrypted password of the Login Enterprise virtual appliance. Will be .<region>.cloudapp.azure.com"
}

variable "appliance_instance_type" {
  description = "Instance size of the Login Enterprise virtual appliance."
}

variable "appliance_private_ip" {
  description = "Private IP of the Virtual Appliance"
}

variable "appliance_storage_account_type" {
  description = "The storage account type for the Virtual Appliance disk"
}

#-----------------------------------------------
# Azure Compute Gallery Image Variables
#-----------------------------------------------
variable "appliance_image_version" {
  description = "Version of the image to deploy from the Azure Compute Gallery (e.g., '1.0.0' or 'latest')."
  type        = string
  default     = "latest"
}

variable "appliance_image_name" {
  description = "The name of the image definition in the Azure Compute Gallery."
  type        = string
  # default     = "loginenterprise-va" # Example; replace with your image name
}

variable "appliance_gallery_name" {
  description = "The name of the Azure Compute Gallery that contains the image."
  type        = string
  # default     = "myGallery" # Example; replace with your gallery name
}

variable "appliance_gallery_resource_group" {
  description = "The resource group where the Azure Compute Gallery is located."
  type        = string
  # default     = "myGalleryRG" # Example; replace with your resource group
}
