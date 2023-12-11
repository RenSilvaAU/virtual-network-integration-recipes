# Generate random string for unique compute instance name
resource "random_string" "ci_prefix" {
  length  = 2
  upper   = false
  special = false
  numeric = false
}

# Compute cluster
resource "azurerm_machine_learning_compute_cluster" "compute" {
  name                          = var.vm_cluster_name
  location                      = data.azurerm_resource_group.default.location
  machine_learning_workspace_id = azurerm_machine_learning_workspace.default.id
  vm_priority                   = "Dedicated"
  vm_size                       = "STANDARD_DS2_V2"
  subnet_resource_id            = data.azurerm_subnet.training.id

  node_public_ip_enabled        = false
  identity {
    type = "SystemAssigned"
  }

  scale_settings {
    min_node_count                       = 0
    max_node_count                       = 3
    scale_down_nodes_after_idle_duration = "PT15M" # 15 minutes
  }

  tags = var.tags

}


# Compute instance - moved into its own module
## resource "azurerm_machine_learning_compute_instance" "compute_instance" {
##   name                          = "${var.vm_instance_name}-${random_string.ci_prefix.result}"
##   location                      = data.azurerm_resource_group.default.location
##   machine_learning_workspace_id = azurerm_machine_learning_workspace.default.id
##   virtual_machine_size          = "Standard_DS2_v2"
##   subnet_resource_id            = data.azurerm_subnet.training.id
## 
##   node_public_ip_enabled        = false
##   depends_on = [
##     azurerm_private_endpoint.mlw_ple
##   ]
## 
##   tags = var.tags
##   # See if this deploys
## }

## resource "azurerm_machine_learning_compute_instance" "compute_instance2" {
##   name                          = "Bjenkins"
##   location                      = data.azurerm_resource_group.default.location
##   machine_learning_workspace_id = azurerm_machine_learning_workspace.default.id
##   virtual_machine_size          = "Standard_DS2_v2"
##   authorization_type            = "personal"
##   subnet_resource_id            = data.azurerm_subnet.training.id
## 
##   node_public_ip_enabled        = false
##   depends_on = [
##     azurerm_private_endpoint.mlw_ple
##   ]
## 
##   assign_to_user {
##     object_id = "f56c3a45-38d5-448b-8a62-9d3a17f1321a"
##     tenant_id = "d92123ce-0eea-489a-85ca-bb4e3dc51e8d"
##   
##   }
##   
##   tags = var.tags
##   # See if this deploys
## }