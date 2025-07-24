# Terraform-Templates
This repository contains Terraform templates created by Nick Campa for use with Login Enterprise Deployments. Currently the repository has templates for:

* Deploying Login Enterprise from an Azure Compute Gallery Image Version

<br>

# Terraform-Appliance-ACG
This template can be used for deploying Login Enterprise from an Azure Compute Gallery Image Version.

## Steps to implement
This README guide will walkthrough the implementation of this Terraform template. The template is not meant to be ready-for-use in every environment, and may require customization to account for preexisting resources, such as virtual networks, IPs, etc.
1. Download the template locally.
2. Read the Setting up your Variables section very closely. This explains what every variable is used for, and some provide examples.
3. Open `terraform.tfvars` to modify the variables according to your tenant, subscription, naming conventions, and requirements.
4. Run `terraform init` from the working folder containing your `Terraform-Appliance-ACG` template.
5. Run `terraform plan` to display the build plan and verify there are no missing variables. There should be a message similar to: `Plan: 10 to add, 0 to change, 0 to destroy.` Please take care not to overwrite or delete any existing cloud resources, unless that is desired.
6. Run `terraform apply` to build the plan that was displayed from step 5.
7. In development settings, run `terraform destroy` to remove the resources created by applying your Terraform configuration.

### Assumptions
This guide assumes:
* There exists a viable Login Enterprise image stored in an Azure Compute Gallery.
* The Login Enterprise image is Generation v1.


### Setting up your Variables
The Terraform template uses the .tfvars file to apply customizations. Here are the available parameters that can be tweaked for your environment:

1. `default_tags`: JSON block of tags to apply to all deployed resources

2. `prefix`: The prefix, e.g., "test" that will be applied to all resources. For example, prefix = "test" will result in a virtual appliance VM named "test-va"

3. `resource_group_name`: This template will create a resource group to store created resources

4. `location`: The template deploys everything into one region, set by this variable. Use Azure standards, e.g., "East US" will be "eastus"

5. `appliance_gallery_resource_group`: The name of the resource group that contains your target ACG

6. `appliance_gallery_name`: The name of the target ACG, where your LE image is stored

7. `appliance_image_name`: The name of your target ACG Image Definition, e.g., "LoginEnterprise"

8. `appliance_image_version`: The version of your target ACG Image Definition to use, e.g., "6.1.14"

9. `dns_servers`: DNS servers to configure the Virtual Network with

10. `vnet_cidr`: The CIDR range to use for the Virtual Network that will be created

11. `snet_cidr`: The CIDR range to use for the Subnet that will be created

12. `appliance_hostname`: The computername to apply to the Virtual Appliance VM. This will not have 
the `prefix` applied to account for 15 char. limits.

13. `appliance_domain_name`: The domain to use for the Appliance FQDN. This will be passed into the cloud-init configuration, i.e., the appliance will be configured to listen for HTTPS on `appliance_hostname.appliance_domain_name` once deployed

14. `appliance_encoded_password`: The base64 encoded password for the root Linux user of the appliance VM. This will be passed into the cloud-init configuration, i.e., this is the password you will use to access the appliance until LDAP is configured.

15. `appliance_private_ip`: The (static) Private IP address to assign the Virtual Appliance NIC.

16. `appliance_storage_account_type`: The storage account type to use for the Virtual Appliance VM OS Disk, e.g., `Standard_LRS`.

17. `appliance_instance_type`: The Virtual Machine SKU used to deploy the Virtual Appliance VM. Login Enterprise requires at least 4vCPU and 8 GB Memory.

Note: The `.tfvars` file contains variables for the Azure Application Object's Client Id and Secret, in addition to the Tenant and Subscription Id. These are not used directly, but the `providers.tf` file has a commented out block that can be used to authenticate in the build process itself, as opposed to using `az login` from the command prompt. Here they are for reference:
    
1. `azure_client_id`: The Application Client Id of the Terraform App Registration

2. `azure_client_secret`: The Client Secret of the Terraform App Registration

3. `azure_tenant_id`: The Azure Tenant Id containing the subscription where resources should be deployed

4. `azure_subscription_id`: The Azure Subscription Id containing where resources should be deployed

### Deployment

The Terraform template will perform the following actions:

1. Read Variables that Point to the Azure Compute Gallery Image Definition & Version

2. Creates a resource group to contain all subsequently created resources
    * This will be named `<prefix>-<resource_group_name>`

3. Creates a Virtual Network, using the defined `vnet_cidr`
    * This will be named `<prefix>-vnet`

4. Creates a Subnet within the Virtual Network, using the defined `snet_cidr`
    * This will be named `<prefix>-snet`

5. Creates a Network Security Group, without any rules
    * This will be named `<prefix>-nsg`

6. Associates the Network Security Group with the Subnet from Step 4.

7. Creates a Static Public IP Address with a domain_name_label for the VM. This can be commented out if internal-only access is desired. Note: This can be commented out, but requires uncommenting the NIC Configuration within `applianceACG.tf`.
    * This will be called `<prefix>-pip`

8. Creates a Network Interface (NIC) and attaches it to the Subnet from Step 4. It assigns a Static Private IP and the Public IP from Step 7.
    * This will be called `<prefix>-nic`

9. Creates the Linux Virtual Machine, using the ACG Image Version read from variables in Step 1. It uses variables to configure its size and storage type.
    * The Azure VM resource will be called `<prefix>-va`, but
    * The Virtual Machine hostname will be `appliance_hostname` as set in the `.tfvars` file.