variable "location" {
  type        = string
  description = "Location of the resources"
  default     = "East US"
}

variable "image_build_compute_name" {
  type        = string
  description = "Name of the compute cluster to be created and set to build docker images"
  default     = "image-builder"
}

variable "rg_name" {
  type        = string
  description = "Name of the existing RG"
}

variable "vm_cluster_name" {
  type        = string
  description = "Name of the vm cluster"
}

variable "vm_instance_name" {
  type        = string
  description = "Name of the compute instance"
}

variable "acr_name" {
  type        = string
  description = "Name of the ACR"
}

variable "sta_name" {
  type        = string
  description = "Name of the Storage Account"
}

variable "mlw_name" {
  type        = string
  description = "Name of the Machine Learning Workspace"
}

variable "akv_name" {
  type        = string
  description = "Name of the Azure Key Vault"
}

variable "appin_name" {
  type        = string
  description = "Name of the Application Insights"
}

# Existing vnet and subnets variables

variable "vnet_resource_group_name" {
  type        = string
  description = "Name of the resource group for the existing VNet"
}

variable "vnet_name" {
  type        = string
  description = "Name of the existing VNet"
}

variable "training_subnet_name" {
  type        = string
  description = "Name of the existing training subnet"
}

variable "aks_subnet_name" {
  type        = string
  description = "Name of the existing aks subnet"
}

variable "ml_subnet_name" {
  type        = string
  description = "Name of the existing ML workspace subnet"
}


# Existing private DNS zones variables
variable "privatelink_api_azureml_ms_resource_id" {
  type        = string
  description = "Resource ID of the existing privatelink.api.azureml.ms private dns zone"
}

variable "privatelink_azurecr_io_resource_id" {
  type        = string
  description = "Resource ID of the existing privatelink.azurecr.io private dns zone"
}

variable "privatelink_notebooks_azure_net_resource_id" {
  type        = string
  description = "Resource ID of the existing privatelink.notebooks.azure.net private dns zone"
}

variable "privatelink_blob_core_windows_net_resource_id" {
  type        = string
  description = "Resource ID of the existing privatelink.blob.core.windows.net private dns zone"
}

variable "privatelink_file_core_windows_net_resource_id" {
  type        = string
  description = "Resource ID of the existing privatelink.file.core.windows.net private dns zone"
}

variable "privatelink_table_core_windows_net_resource_id" {
  type        = string
  description = "Resource ID of the existing privatelink.table.core.windows.net private dns zone"
}

variable "privatelink_vaultcore_azure_net_resource_id" {
  type        = string
  description = "Resource ID of the existing privatelink.vaultcore.azure.net private dns zone"
}

variable "tags" {
  type        = map(string)
  description = "tags to apply to the resources"
}