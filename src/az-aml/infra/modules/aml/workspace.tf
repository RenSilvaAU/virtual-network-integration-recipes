# Dependent resources for Azure Machine Learning
resource "azurerm_application_insights" "default" {
  name                = var.appin_name
  location            = data.azurerm_resource_group.default.location
  resource_group_name = data.azurerm_resource_group.default.name
  application_type    = "web"

  tags = var.tags
}

resource "azurerm_key_vault" "default" {
  name                     = var.akv_name
  location                 = data.azurerm_resource_group.default.location
  resource_group_name      = data.azurerm_resource_group.default.name
  tenant_id                = data.azurerm_client_config.current.tenant_id
  sku_name                 = "premium"
  purge_protection_enabled = true

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }

  tags = var.tags
}

resource "azurerm_storage_account" "default" {
  name                            = var.sta_name
  location                        = data.azurerm_resource_group.default.location
  resource_group_name             = data.azurerm_resource_group.default.name
  account_tier                    = "Standard"
  account_replication_type        = "GRS"
  allow_nested_items_to_be_public = false
  min_tls_version                 = "TLS1_2"

  network_rules {
    default_action = "Deny"
    bypass         = ["AzureServices"]
    private_link_access {
      endpoint_resource_id = "/subscriptions/31e50174-228a-451f-9eba-a903458b5fd9/resourcegroups/BGL-NPE-ARG-SwiftSolvePOC-AML/providers/Microsoft.MachineLearningServices/workspaces/bglnpeuatsydmlwswiftaml"
      endpoint_tenant_id   = "d92123ce-0eea-489a-85ca-bb4e3dc51e8d"
    }
  }

  tags = var.tags
}

resource "azurerm_container_registry" "default" {
  name                = var.acr_name
  location            = data.azurerm_resource_group.default.location
  resource_group_name = data.azurerm_resource_group.default.name
  sku                 = "Premium"
  admin_enabled       = true

  network_rule_set {
    default_action = "Deny"
  }
  public_network_access_enabled = false

  tags = var.tags
}

# Machine Learning workspace
resource "azurerm_machine_learning_workspace" "default" {
  name                    = var.mlw_name
  location                = data.azurerm_resource_group.default.location
  resource_group_name     = data.azurerm_resource_group.default.name
  application_insights_id = azurerm_application_insights.default.id
  key_vault_id            = azurerm_key_vault.default.id
  storage_account_id      = azurerm_storage_account.default.id
  container_registry_id   = azurerm_container_registry.default.id

  identity {
    type = "SystemAssigned"
  }

  # Args of use when using an Azure Private Link configuration
  public_network_access_enabled = false
  image_build_compute_name      = var.image_build_compute_name

  tags = var.tags

}

# Private endpoints
resource "azurerm_private_endpoint" "kv_ple" {
  name                = "BGL-NPE-UAT-SYD-PEP-kv"
  location            = data.azurerm_resource_group.default.location
  resource_group_name = data.azurerm_resource_group.default.name
  subnet_id           = data.azurerm_subnet.ml.id

  private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [var.privatelink_vaultcore_azure_net_resource_id]
  }

  private_service_connection {
    name                           = "bgl-npe-uat-syd-psc-kv"
    private_connection_resource_id = azurerm_key_vault.default.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  tags = var.tags

}

resource "azurerm_private_endpoint" "st_ple_blob" {
  name                = "BGL-NPE-UAT-SYD-PEP-st-blob"
  location            = data.azurerm_resource_group.default.location
  resource_group_name = data.azurerm_resource_group.default.name
  subnet_id           = data.azurerm_subnet.ml.id

  private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [var.privatelink_blob_core_windows_net_resource_id]
  }

  private_service_connection {
    name                           = "bgl-npe-uat-syd-psc-st"
    private_connection_resource_id = azurerm_storage_account.default.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  tags = var.tags

}

resource "azurerm_private_endpoint" "storage_ple_file" {
  name                = "BGL-NPE-UAT-SYD-PEP-st-file"
  location            = data.azurerm_resource_group.default.location
  resource_group_name = data.azurerm_resource_group.default.name
  subnet_id           = data.azurerm_subnet.ml.id

  private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [var.privatelink_file_core_windows_net_resource_id]
  }

  private_service_connection {
    name                           = "bgl-npe-uat-syd-psc-st"
    private_connection_resource_id = azurerm_storage_account.default.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

  tags = var.tags

}

resource "azurerm_private_endpoint" "storage_ple_table" {
  name                = "BGL-NPE-UAT-SYD-PEP-st-table"
  location            = data.azurerm_resource_group.default.location
  resource_group_name = data.azurerm_resource_group.default.name
  subnet_id           = data.azurerm_subnet.ml.id

  private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [var.privatelink_table_core_windows_net_resource_id]
  }

  private_service_connection {
    name                           = "bgl-npe-uat-syd-psc-st"
    private_connection_resource_id = azurerm_storage_account.default.id
    subresource_names              = ["table"]
    is_manual_connection           = false
  }

  tags = var.tags

}

resource "azurerm_private_endpoint" "cr_ple" {
  name                = "BGL-NPE-UAT-SYD-PEP-cr"
  location            = data.azurerm_resource_group.default.location
  resource_group_name = data.azurerm_resource_group.default.name
  subnet_id           = data.azurerm_subnet.ml.id

  private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [var.privatelink_azurecr_io_resource_id]
  }

  private_service_connection {
    name                           = "bgl-npe-uat-syd-psc-cr"
    private_connection_resource_id = azurerm_container_registry.default.id
    subresource_names              = ["registry"]
    is_manual_connection           = false
  }

  tags = var.tags

}

resource "azurerm_private_endpoint" "mlw_ple" {
  name                = "BGL-NPE-UAT-SYD-PEP-mlw"
  location            = data.azurerm_resource_group.default.location
  resource_group_name = data.azurerm_resource_group.default.name
  subnet_id           = data.azurerm_subnet.ml.id

  private_dns_zone_group {
    name = "private-dns-zone-group"
    private_dns_zone_ids = [
      var.privatelink_api_azureml_ms_resource_id,
      var.privatelink_notebooks_azure_net_resource_id
    ]
  }

  private_service_connection {
    name                           = "bgl-npe-uat-syd-psc-mlw"
    private_connection_resource_id = azurerm_machine_learning_workspace.default.id
    subresource_names              = ["amlworkspace"]
    is_manual_connection           = false
  }

  tags = var.tags
  
}

# Compute cluster for image building required since the workspace is behind a vnet.
# For more details, see https://docs.microsoft.com/en-us/azure/machine-learning/tutorial-create-secure-workspace#configure-image-builds.
resource "azurerm_machine_learning_compute_cluster" "image-builder" {
  name                          = var.image_build_compute_name
  location                      = data.azurerm_resource_group.default.location
  vm_priority                   = "LowPriority"
  vm_size                       = "STANDARD_DS2_V2"
  machine_learning_workspace_id = azurerm_machine_learning_workspace.default.id
  subnet_resource_id            = data.azurerm_subnet.training.id

  node_public_ip_enabled        = false
  
  scale_settings {
    min_node_count                       = 0
    max_node_count                       = 3
    scale_down_nodes_after_idle_duration = "PT15M" # 15 minutes
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags

}

# Managed workspace Identity permissions on storage account

resource "azurerm_role_assignment" "storageblobdatacontributor" {
  for_each = { 
    for id in azurerm_machine_learning_workspace.default.identity : id.principal_id => {
      id = id.principal_id
    }
  }
  scope                 = azurerm_storage_account.default.id
  role_definition_name  = "Storage Blob Data Contributor"
  principal_id          = each.value.id
}

resource "azurerm_role_assignment" "storagetabledatacontributor" {
  for_each = { 
    for id in azurerm_machine_learning_workspace.default.identity : id.principal_id => {
      id = id.principal_id
    }
  }
  scope                 = azurerm_storage_account.default.id
  role_definition_name  = "Storage Table Data Contributor"
  principal_id          = each.value.id
}

