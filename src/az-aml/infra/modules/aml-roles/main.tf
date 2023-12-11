data "azurerm_client_config" "current" {}

#locals {
#    group_list = var.group_name
#    assign_roles = var.roles
#
#    resource_group_role_assignments = {for val in setproduct(local.group_list, local.assign_roles):
#                "${val[0]}-${val[1]}" => val}  
#
#}

data "azurerm_resource_group" "default" {
  name     = var.rg_name
}

data "azuread_group" "this" {
  #for_each         = toset(["BGL-AZ-MS-SwiftSolve", "BGL-AZ-SwiftSolve"])
  display_name     = var.group_name
  security_enabled = true
}

resource "azurerm_role_assignment" "azuremldatascientist" {
  #for_each = data.azuread_group.this
  #for_each = { 
  #  for record in data.azuread_group.this : record.id => {
  #    id = record.id
  #  }
  #}
  scope                 = data.azurerm_resource_group.default.id
  role_definition_name  = "AzureML Data Scientist"
  principal_id          = data.azuread_group.this.id

  #depends_on = [ data.azuread_group.this ]
}

resource "azurerm_role_assignment" "storageblobdatacontributor" {
  #for_each = data.azuread_group.this
  #for_each = { 
  #  for record in data.azuread_group.this : record.id => {
  #    id = record.id
  #  }
  #}
  scope                 = data.azurerm_resource_group.default.id
  role_definition_name  = "Storage Blob Data Contributor"
  principal_id          = data.azuread_group.this.id

  #depends_on = [ data.azuread_group.this ]
}

resource "azurerm_role_assignment" "storagetabledatacontributor" {
  #for_each = data.azuread_group.this
  #for_each = { 
  #  for record in data.azuread_group.this : record.id => {
  #    id = record.id
  #  }
  #}
  scope                 = data.azurerm_resource_group.default.id
  role_definition_name  = "Storage Table Data Contributor"
  principal_id          = data.azuread_group.this.id

  #depends_on = [ data.azuread_group.this ]
}
