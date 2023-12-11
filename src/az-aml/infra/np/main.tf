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
  skip_provider_registration = true
  features {}
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
    Description = "OpenAI PoC 2 for SwiftSolve"
  }
  sql_admin_user = {
    user_name     = "swiftsolvedbadmin-npe"
    keyvault_name = "bglnpesydakvswiftsolve"
    keyvault_rg   = "BGL-NPE-ARG-SwiftSolvePOC"
    secret_name   = "sqldbadmin"
  }
}

module "swiftsolve" {
  source = "../modules/swiftsolve"

  rg_name           = "BGL-NPE-ARG-SwiftSolvePOC"
  location          = "australiaeast"
  vnet_rg_name      = "BGL-NPE-ARG-Network"
  vnet_name         = "BGL-SYD-NPE-UAT-VNT-10.4.128.0"
  pep_dnsz_rg_name  = "bgl-cor-arg-pridnsz"
  subnet_name       = "BGL-PRD-SYD-SUB-SWIFTSOLVE-01"
  akv_name          = "bglnpesydakvswiftsolve"
  tags              = local.tags

  storageaccounts = {
    bglnpestaswiftsolvepoc1 = {
      name      = "bglnpestaswiftsolvepoc1",
      location  = "australiaeast"
      container = "unstructureddocs"
    }
    bglnpestaswiftsolvepoc3 = {
      name      = "bglnpestaswiftsolvepoc3",
      location  = "australiaeast"
      container = "restricted"
    }
  }

  #swastorageaccounts = {
  #  bglnpestaswiftsolveswa1 = {
  #    name      = "bglnpestaswiftsolveswa1",
  #    location  = "australiaeast"
  #  }
  #}

  # SQL Server
  sql_server_name     = "bgl-npe-syd-sql-svr-swiftsolve"
  sql_admin_user      = local.sql_admin_user
  sql_db_name         = "npeswiftsolve-teamassist"

  # Cognitive Services inc text-embedding-ada-002
  openai_account      = "bglnpeopenaiswiftsolve"
  cog_account         = "bglnpecogswiftsolve"
  az_search           = "bglnpesearchswiftsolve"
  cog_account_ae      = "bglnpecogswiftsolve-ae"

  appin_name          = "BGL-NPE-UAT-SYD-AIN-SwiftSolve"

}
