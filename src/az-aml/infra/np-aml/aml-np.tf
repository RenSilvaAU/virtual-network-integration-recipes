terraform {
  backend "azurerm" {
    resource_group_name  = "rsg-swiftsolve-01"
    storage_account_name = "asa-swiftsolve-01"
    container_name       = "tfstate"
    key                  = "swiftsolve.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">3.69.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">=2.41.0"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

provider "azuread" {

}

locals {
  tags = {
    Environment = "NPE"
    Owner       = "BGLBusinessImpr"
    CostCenter  = "1039"
    CreatedBy   = "juan.burckhardt@microsoft.com"
    Contact     = "juan.burckhardt@microsoft.com"
    Description = "SwiftSolve POC - Azure Machine Learning Deployment"
  }

}

#module "aml" {
#  source = "../modules/aml"
#
#  rg_name                                         = "BGL-NPE-ARG-SwiftSolvePOC-AML"
#  location                                        = "australiaeast"
#  vm_cluster_name                                 = "blgnpeuatsydmlwclu"
#  vm_instance_name                                = "blgnpeuatsydmlwins"
#  vnet_name                                       = "BGL-SYD-NPE-UAT-VNT-10.4.128.0" # Name of the existing VNet
#  vnet_resource_group_name                        = "BGL-NPE-ARG-Network" # Name of the existing VNet Resource Group
#  ml_subnet_name                                  = "BGL-PRD-SYD-SUB-AML-ML-01" # Name of the existing ML workspace subnet
#  aks_subnet_name                                 = "BGL-PRD-SYD-SUB-AML-AKS-01" # Name of the existing aks subnet
#  training_subnet_name                            = "BGL-PRD-SYD-SUB-AML-TRAINING-01" # Name of the existing training subnet
#  image_build_compute_name                        = "bglnpeuatsydmlwimg" #"BGL-NPE-UAT-SYD-MLW-IMGBuild" # Name of the compute cluster to be created and configured for building docker images (Azure ML Environments)
#  privatelink_api_azureml_ms_resource_id	        = "/subscriptions/979a7ec4-4c01-4027-acaa-b12b83e4f540/resourceGroups/bgl-cor-arg-pridnsz/providers/Microsoft.Network/privateDnsZones/privatelink.api.azureml.ms"
#  privatelink_azurecr_io_resource_id	            = "/subscriptions/979a7ec4-4c01-4027-acaa-b12b83e4f540/resourceGroups/bgl-cor-arg-pridnsz/providers/Microsoft.Network/privateDnsZones/privatelink.azurecr.io"
#  privatelink_notebooks_azure_net_resource_id     = "/subscriptions/979a7ec4-4c01-4027-acaa-b12b83e4f540/resourceGroups/bgl-cor-arg-pridnsz/providers/Microsoft.Network/privateDnsZones/privatelink.notebooks.azure.net"
#  privatelink_blob_core_windows_net_resource_id   = "/subscriptions/979a7ec4-4c01-4027-acaa-b12b83e4f540/resourceGroups/bgl-cor-arg-pridnsz/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"
#  privatelink_file_core_windows_net_resource_id   = "/subscriptions/979a7ec4-4c01-4027-acaa-b12b83e4f540/resourceGroups/bgl-cor-arg-pridnsz/providers/Microsoft.Network/privateDnsZones/privatelink.file.core.windows.net"
#  privatelink_vaultcore_azure_net_resource_id     = "/subscriptions/979a7ec4-4c01-4027-acaa-b12b83e4f540/resourceGroups/bgl-cor-arg-pridnsz/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net"
#  privatelink_table_core_windows_net_resource_id  = "/subscriptions/979a7ec4-4c01-4027-acaa-b12b83e4f540/resourceGroups/bgl-cor-arg-pridnsz/providers/Microsoft.Network/privateDnsZones/privatelink.table.core.windows.net"
#  acr_name                                        = "bglnpeuatsydacrswiftaml"
#  sta_name                                        = "bglnpeuatsydstaswiftaml" # 3-24 chars
#  mlw_name                                        = "bglnpeuatsydmlwswiftaml"
#  akv_name                                        = "bglnpeuatsydakvswiftaml" # 3-24 chars
#  appin_name                                      = "BGL-NPE-UAT-SYD-AIN-SwiftSolveAML"
#
#  tags              = local.tags
#
#}




module "amlroles_ms_swiftsolve" {
  source = "../modules/aml-roles"

  rg_name                                       = "BGL-NPE-ARG-SwiftSolvePOC-AML"
  group_name                                    = "BGL-AZ-MS-SwiftSolve"#, "BGL-AZ-SwiftSolve"] # Display Name for the group

}

module "amlroles_swiftsolve" {
  source = "../modules/aml-roles"

  rg_name                                       = "BGL-NPE-ARG-SwiftSolvePOC-AML"
  group_name                                    = "BGL-AZ-SwiftSolve" # Display Name for the group

}



# Second Instance of AML to attempt to fix bug

module "aml2" {
  source = "../modules/aml2"

  rg_name                                         = "BGL-NPE-ARG-SwiftSolvePOC-AML2"
  location                                        = "australiaeast"
  vm_cluster_name                                 = "blgnpeuatsydmlwclu2"
  vm_instance_name                                = "blgnpeuatsydmlwins2"
  vnet_name                                       = "BGL-SYD-NPE-UAT-VNT-10.4.128.0" # Name of the existing VNet
  vnet_resource_group_name                        = "BGL-NPE-ARG-Network" # Name of the existing VNet Resource Group
  ml_subnet_name                                  = "BGL-PRD-SYD-SUB-AML-ML-01" # Name of the existing ML workspace subnet
  aks_subnet_name                                 = "BGL-PRD-SYD-SUB-AML-AKS-01" # Name of the existing aks subnet
  training_subnet_name                            = "BGL-PRD-SYD-SUB-AML-TRAINING-01" # Name of the existing training subnet
  image_build_compute_name                        = "bglnpeuatsydmlwimg2" #"BGL-NPE-UAT-SYD-MLW-IMGBuild" # Name of the compute cluster to be created and configured for building docker images (Azure ML Environments)
  privatelink_api_azureml_ms_resource_id	        = "/subscriptions/979a7ec4-4c01-4027-acaa-b12b83e4f540/resourceGroups/bgl-cor-arg-pridnsz/providers/Microsoft.Network/privateDnsZones/privatelink.api.azureml.ms"
  privatelink_azurecr_io_resource_id	            = "/subscriptions/979a7ec4-4c01-4027-acaa-b12b83e4f540/resourceGroups/bgl-cor-arg-pridnsz/providers/Microsoft.Network/privateDnsZones/privatelink.azurecr.io"
  privatelink_notebooks_azure_net_resource_id     = "/subscriptions/979a7ec4-4c01-4027-acaa-b12b83e4f540/resourceGroups/bgl-cor-arg-pridnsz/providers/Microsoft.Network/privateDnsZones/privatelink.notebooks.azure.net"
  privatelink_blob_core_windows_net_resource_id   = "/subscriptions/979a7ec4-4c01-4027-acaa-b12b83e4f540/resourceGroups/bgl-cor-arg-pridnsz/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"
  privatelink_file_core_windows_net_resource_id   = "/subscriptions/979a7ec4-4c01-4027-acaa-b12b83e4f540/resourceGroups/bgl-cor-arg-pridnsz/providers/Microsoft.Network/privateDnsZones/privatelink.file.core.windows.net"
  privatelink_vaultcore_azure_net_resource_id     = "/subscriptions/979a7ec4-4c01-4027-acaa-b12b83e4f540/resourceGroups/bgl-cor-arg-pridnsz/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net"
  privatelink_table_core_windows_net_resource_id  = "/subscriptions/979a7ec4-4c01-4027-acaa-b12b83e4f540/resourceGroups/bgl-cor-arg-pridnsz/providers/Microsoft.Network/privateDnsZones/privatelink.table.core.windows.net"
  acr_name                                        = "bglnpeuatsydacrswiftaml2"
  sta_name                                        = "bglnpeuatsydstaswiftaml2" # 3-24 chars
  mlw_name                                        = "bglnpeuatsydmlwswiftaml2"
  akv_name                                        = "bglnpeuatsydakvswiftaml2" # 3-24 chars
  appin_name                                      = "BGL-NPE-UAT-SYD-AIN-SwiftSolveAML2"

  tags              = local.tags

}

module "amlroles2_ms_swiftsolve" {
  source = "../modules/aml-roles"

  rg_name                                       = module.aml2.aml_rg
  group_name                                    = "BGL-AZ-MS-SwiftSolve"#, "BGL-AZ-SwiftSolve"] # Display Name for the group

}

module "amlroles2_swiftsolve" {
  source = "../modules/aml-roles"

  rg_name                                       = module.aml2.aml_rg
  group_name                                    = "BGL-AZ-SwiftSolve" # Display Name for the group

}




module "amlinstances2-sd" {
  source = "../modules/aml-instance"

  rg_name                                       = module.aml2.aml_rg
  location                                      = "australiaeast"
  vnet_resource_group_name                      = "BGL-NPE-ARG-Network" # Name of the existing VNet Resource Group
  vnet_name                                     = "BGL-SYD-NPE-UAT-VNT-10.4.128.0" # Name of the existing VNet
  training_subnet_name                          = "BGL-PRD-SYD-SUB-AML-TRAINING-01" # Name of the existing training subnet
  mlw_name                                      = module.aml2.aml_mlw_name #"bglnpeuatsydmlwswiftaml2"

  upns                                          = "juan.burckhardt@microsoft.com" # Comma separated list for each user that requires a Azure AI Studio Machine Learning Workspace Compute Instance (full UPN)
  managed_identity                              = "/subscriptions/31e50174-228a-451f-9eba-a903458b5fd9/resourceGroups/BGL-NPE-ARG-SwiftSolvePOC-AML2/providers/Microsoft.ManagedIdentity/userAssignedIdentities/BGL-NPE-UAT-MI-SwiftSolve-AML2"
  tags                                          = local.tags

  depends_on = [ module.aml2 ]
}

module "amlinstances2-rs" {
  source = "../modules/aml-instance"

  rg_name                                       = module.aml2.aml_rg
  location                                      = "australiaeast"
  vnet_resource_group_name                      = "BGL-NPE-ARG-Network" # Name of the existing VNet Resource Group
  vnet_name                                     = "BGL-SYD-NPE-UAT-VNT-10.4.128.0" # Name of the existing VNet
  training_subnet_name                          = "BGL-PRD-SYD-SUB-AML-TRAINING-01" # Name of the existing training subnet
  mlw_name                                      = module.aml2.aml_mlw_name #"bglnpeuatsydmlwswiftaml2"

  upns                                          = "juan.burckhardt@microsoft.com" # Comma separated list for each user that requires a Azure AI Studio Machine Learning Workspace Compute Instance (full UPN)
  managed_identity                              = "/subscriptions/31e50174-228a-451f-9eba-a903458b5fd9/resourceGroups/BGL-NPE-ARG-SwiftSolvePOC-AML2/providers/Microsoft.ManagedIdentity/userAssignedIdentities/BGL-NPE-UAT-MI-SwiftSolve-AML2"
  tags                                          = local.tags

  depends_on = [ module.aml2 ]
}

module "amlinstances2-kf" {
  source = "../modules/aml-instance"

  rg_name                                       = module.aml2.aml_rg
  location                                      = "australiaeast"
  vnet_resource_group_name                      = "BGL-NPE-ARG-Network" # Name of the existing VNet Resource Group
  vnet_name                                     = "BGL-SYD-NPE-UAT-VNT-10.4.128.0" # Name of the existing VNet
  training_subnet_name                          = "BGL-PRD-SYD-SUB-AML-TRAINING-01" # Name of the existing training subnet
  mlw_name                                      = module.aml2.aml_mlw_name #"bglnpeuatsydmlwswiftaml2"

  upns                                          = "juan.burckhardt@microsoft.com" # Comma separated list for each user that requires a Azure AI Studio Machine Learning Workspace Compute Instance (full UPN)
  managed_identity                              = "/subscriptions/31e50174-228a-451f-9eba-a903458b5fd9/resourceGroups/BGL-NPE-ARG-SwiftSolvePOC-AML2/providers/Microsoft.ManagedIdentity/userAssignedIdentities/BGL-NPE-UAT-MI-SwiftSolve-AML2"
  tags                                          = local.tags

  depends_on = [ module.aml2 ]
}

module "amlinstances2-dr" {
  source = "../modules/aml-instance"

  rg_name                                       = module.aml2.aml_rg
  location                                      = "australiaeast"
  vnet_resource_group_name                      = "BGL-NPE-ARG-Network" # Name of the existing VNet Resource Group
  vnet_name                                     = "BGL-SYD-NPE-UAT-VNT-10.4.128.0" # Name of the existing VNet
  training_subnet_name                          = "BGL-PRD-SYD-SUB-AML-TRAINING-01" # Name of the existing training subnet
  mlw_name                                      = module.aml2.aml_mlw_name #"bglnpeuatsydmlwswiftaml2"

  upns                                          = "juan.burckhardt@microsoft.com" # Comma separated list for each user that requires a Azure AI Studio Machine Learning Workspace Compute Instance (full UPN)
  managed_identity                              = "/subscriptions/31e50174-228a-451f-9eba-a903458b5fd9/resourceGroups/BGL-NPE-ARG-SwiftSolvePOC-AML2/providers/Microsoft.ManagedIdentity/userAssignedIdentities/BGL-NPE-UAT-MI-SwiftSolve-AML2"
  tags                                          = local.tags

  depends_on = [ module.aml2 ]
}

module "amlinstances2-bm" {
  source = "../modules/aml-instance"

  rg_name                                       = module.aml2.aml_rg
  location                                      = "australiaeast"
  vnet_resource_group_name                      = "BGL-NPE-ARG-Network" # Name of the existing VNet Resource Group
  vnet_name                                     = "BGL-SYD-NPE-UAT-VNT-10.4.128.0" # Name of the existing VNet
  training_subnet_name                          = "BGL-PRD-SYD-SUB-AML-TRAINING-01" # Name of the existing training subnet
  mlw_name                                      = module.aml2.aml_mlw_name #"bglnpeuatsydmlwswiftaml2"

  upns                                          = "juan.burckhardt@microsoft.com" # Comma separated list for each user that requires a Azure AI Studio Machine Learning Workspace Compute Instance (full UPN)
  managed_identity                              = "/subscriptions/31e50174-228a-451f-9eba-a903458b5fd9/resourceGroups/BGL-NPE-ARG-SwiftSolvePOC-AML2/providers/Microsoft.ManagedIdentity/userAssignedIdentities/BGL-NPE-UAT-MI-SwiftSolve-AML2"
  tags                                          = local.tags

  depends_on = [ module.aml2 ]
}

module "amlinstances2-jb" {
  source = "../modules/aml-instance"

  rg_name                                       = module.aml2.aml_rg
  location                                      = "australiaeast"
  vnet_resource_group_name                      = "BGL-NPE-ARG-Network" # Name of the existing VNet Resource Group
  vnet_name                                     = "BGL-SYD-NPE-UAT-VNT-10.4.128.0" # Name of the existing VNet
  training_subnet_name                          = "BGL-PRD-SYD-SUB-AML-TRAINING-01" # Name of the existing training subnet
  mlw_name                                      = module.aml2.aml_mlw_name #"bglnpeuatsydmlwswiftaml2"

  upns                                          = "juan.burckhardt@microsoft.com" # Comma separated list for each user that requires a Azure AI Studio Machine Learning Workspace Compute Instance (full UPN)
  managed_identity                              = "/subscriptions/31e50174-228a-451f-9eba-a903458b5fd9/resourceGroups/BGL-NPE-ARG-SwiftSolvePOC-AML2/providers/Microsoft.ManagedIdentity/userAssignedIdentities/BGL-NPE-UAT-MI-SwiftSolve-AML2"
  tags                                          = local.tags

  depends_on = [ module.aml2 ]
}


module "amlinstances2-bj" {
  source = "../modules/aml-instance"

  rg_name                                       = module.aml2.aml_rg
  location                                      = "australiaeast"
  vnet_resource_group_name                      = "BGL-NPE-ARG-Network" # Name of the existing VNet Resource Group
  vnet_name                                     = "BGL-SYD-NPE-UAT-VNT-10.4.128.0" # Name of the existing VNet
  training_subnet_name                          = "BGL-PRD-SYD-SUB-AML-TRAINING-01" # Name of the existing training subnet
  mlw_name                                      = module.aml2.aml_mlw_name #"bglnpeuatsydmlwswiftaml2"

  upns                                          = "juan.burckhardt@microsoft.com" # Comma separated list for each user that requires a Azure AI Studio Machine Learning Workspace Compute Instance (full UPN)
  managed_identity                              = "/subscriptions/31e50174-228a-451f-9eba-a903458b5fd9/resourceGroups/BGL-NPE-ARG-SwiftSolvePOC-AML2/providers/Microsoft.ManagedIdentity/userAssignedIdentities/BGL-NPE-UAT-MI-SwiftSolve-AML2"
  tags                                          = local.tags

  depends_on = [ module.aml2 ]
}
