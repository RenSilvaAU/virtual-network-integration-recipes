
variable "rg_name" {
  description = "The resource group to provision the resources in"
}

variable "location" {
  description = "The location to provision the resources in"
}

variable "vnet_rg_name" {
  description = "The resource group of the virtual network for Private Endpoints"
}

variable "vnet_name" {
  description = "The name the virtual network to provision the resource in. The VM will be provisioned in the same location as this virtual network"
}

variable "tags" {
  type        = map(string)
  description = "tags to apply to the VM resource"
}

variable "pep_dnsz_rg_name" {
  description = "The resource group of the DNS Zones for the Private Endpoints"
}

variable "subnet_name" {
  description = "The name the subnet for the PEP"
}
variable "storageaccounts" {
    type = map(object({
        name      = optional(string)
        location  = optional(string)
        container = optional(string)
      }))
      default = {}
    } 

variable "swastorageaccounts" {
    type = map(object({
        name      = optional(string)
        location  = optional(string)
      }))
      default = {}
    } 
variable "akv_name" {
  description = "The name the AKV"
}
variable "sql_admin_user" {
  type = object({
    user_name     = string,
    keyvault_name = string,
    keyvault_rg   = string,
    secret_name   = string
  })
  description = "The admin user details to use for the VM. This consists of a username, and then a keyvault name, resource group and secret name in that keyvault to fetch the password from. This is just for initial setup, typically will be reset by group policy"
}



variable "sql_server_name" {
  description = "The name SQL Server"
}

variable "sql_db_name" {
  description = "The name SQL DB"
}

variable "openai_account" {
  description = "The name for the OpenAI Account"
}

variable "cog_account" {
  description = "The name for the Cognitive Services Account"
}

variable "az_search" {
  description = "The name for the Cognitive Services Account"
}

variable "cog_account_ae" {
  description = "The name for the Cognitive Services Account for Australia East"
}

variable "appin_name" {
  type        = string
  description = "Name of the Application Insights"
}
