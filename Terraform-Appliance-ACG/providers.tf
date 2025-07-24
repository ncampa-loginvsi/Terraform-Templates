#--------------------------------------
# Providers
#--------------------------------------
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.77.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "=3.1.0"
    }
    null = {
      version = "~> 3.0.0"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = true
  features {}
}

/*
provider "azurerm" {
  features = {}

  client_id       = var.azure_client_id
  client_secret   = var.azure_client_secret
  tenant_id       = var.azure_tenant_id
  subscription_id = var.azure_subscription_id
}

*/