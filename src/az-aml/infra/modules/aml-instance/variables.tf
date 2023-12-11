variable "location" {
  type        = string
  description = "Location of the resources"
  default     = "East US"
}

variable "rg_name" {
  type        = string
  description = "Name of the existing RG"
}

variable "mlw_name" {
  type        = string
  description = "Name of the Machine Learning Workspace"
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

variable "upns" {
  description = "UPN's for each account that requires a Az AI MLW Compute Instance"
  #type        = list(string)
  type        = string
}

variable "tags" {
  type        = map(string)
  description = "tags to apply to the resources"
}

variable "managed_identity" {
  type        = string
  description = "Name of the Managed Identity to be applied to the Compute Instance"
}