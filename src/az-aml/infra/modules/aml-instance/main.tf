data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "default" {
  name     = var.rg_name
}

data "azuread_user" "this" {
  user_principal_name = var.upns  #
}

data "azurerm_subnet" "training" {
  name                 = var.training_subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_resource_group_name
}

data "azurerm_machine_learning_workspace" "default" {
  name                = var.mlw_name
  resource_group_name = data.azurerm_resource_group.default.name
}


resource "azurerm_machine_learning_compute_instance" "compute_instance" {
  #for_each = { 
  #  for record in data.azuread_user.this : record.id => {
  #    id = record.id
  #    upn = record.user_principal_name
  #  }
  #}

  name                          = split("@", data.azuread_user.this.user_principal_name)[0]
  location                      = data.azurerm_resource_group.default.location
  machine_learning_workspace_id = data.azurerm_machine_learning_workspace.default.id
  virtual_machine_size          = "STANDARD_DS2_V2"
  authorization_type            = "personal"
  subnet_resource_id            = data.azurerm_subnet.training.id

  node_public_ip_enabled        = false

  identity {
            identity_ids = [ var.managed_identity ]
            type         = "UserAssigned"
  }
  assign_to_user {
    object_id = data.azuread_user.this.id #each.value.id 
    tenant_id = "d92123ce-0eea-489a-85ca-bb4e3dc51e8d"
  
  }
  
  tags = var.tags

  depends_on = [ data.azuread_user.this ]
}
