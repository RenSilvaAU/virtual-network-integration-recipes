terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

data "azurerm_client_config" "current" {}
data "azurerm_resource_group" "this" {
  name     = var.rg_name
}


data "azurerm_resource_group" "network" {
  name     = var.vnet_rg_name
}

data "azurerm_subnet" "network" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_rg_name
}

resource "azurerm_key_vault" "this" {
  name                     = var.akv_name
  location                 = data.azurerm_resource_group.this.location
  resource_group_name      = data.azurerm_resource_group.this.name
  tenant_id                = data.azurerm_client_config.current.tenant_id
  sku_name                 = "premium"
  purge_protection_enabled = true

  #network_acls {
  #  default_action = "Deny"
  #  bypass         = "AzureServices"
  #}

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Create",
      "Delete",
      "Get",
      "Purge",
      "Recover",
      "Update",
      "GetRotationPolicy",
      "SetRotationPolicy"
    ]

    secret_permissions = [
      "Set",
      "Get",
      "List"
    ]
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [ access_policy ]
  }
}

resource "azurerm_private_endpoint" "kv_ple" {
  name                = "${var.akv_name}-kv"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
  subnet_id           = data.azurerm_subnet.network.id

  private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = ["/subscriptions/979a7ec4-4c01-4027-acaa-b12b83e4f540/resourceGroups/bgl-cor-arg-pridnsz/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net"]
  }

  private_service_connection {
    name                           = "${var.akv_name}-psc-kv"
    private_connection_resource_id = azurerm_key_vault.this.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  tags = var.tags

}

#data "azurerm_resource_group" "dns" {
#  provider  = azurerm.shr
#  name      = var.pep_dnsz_rg_name
#}

# Create a storage account
resource "azurerm_storage_account" "storage" {

  for_each = {
    for key, value in var.storageaccounts :
    key => value
  }

  name                              = each.value.name
  resource_group_name               = data.azurerm_resource_group.this.name
  location                          = each.value.location
  account_tier                      = "Standard"
  account_replication_type          = "LRS"
  #public_network_access_enabled     = false 
  allow_nested_items_to_be_public   = false
  min_tls_version                   = "TLS1_2"
  
  tags = var.tags

  lifecycle {
    ignore_changes = all
  }
}

# Create static web app storage account
resource "azurerm_storage_account" "swastorage" {

  for_each = {
    for key, value in var.swastorageaccounts :
    key => value
  }

  name                              = each.value.name
  resource_group_name               = data.azurerm_resource_group.this.name
  location                          = each.value.location
  account_tier                      = "Standard"
  account_kind                      = "StorageV2"
  account_replication_type          = "LRS"
  #public_network_access_enabled     = false 
  allow_nested_items_to_be_public   = false
  min_tls_version                   = "TLS1_2"
  
  tags = var.tags

  network_rules {
    default_action             = "Deny"
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }

  static_website {
    index_document     = "index.html"
    error_404_document = "error_404.html"
  }
  lifecycle {
    ignore_changes = all
  }
}


resource "azurerm_storage_container" "container" {

  for_each = {
    for key, value in var.storageaccounts :
    key => value
  }
  name                  = each.value.container
  storage_account_name  = each.value.name
  container_access_type = "private"

  depends_on = [ azurerm_storage_account.storage ]
  
  lifecycle {
    ignore_changes = all
  }
  
}

# Create a private DNS zone in the DNS resource group
## resource "azurerm_private_dns_zone" "example" {
##   name                = "privatelink.blob.core.windows.net"
##   resource_group_name = dataazurerm_resource_group.dns.name
## }

# Create a private endpoint
resource "azurerm_private_endpoint" "storage" {

  for_each = {
    for key, value in azurerm_storage_account.storage :
    key => value
  }
  name                = each.value.name
  location            = each.value.location
  resource_group_name = data.azurerm_resource_group.this.name
  subnet_id           = data.azurerm_subnet.network.id # "/subscriptions/your-subscription-id/resourceGroups/your-network-rg/providers/Microsoft.Network/virtualNetworks/your-vnet/subnets/your-subnet"
  
  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = ["/subscriptions/979a7ec4-4c01-4027-acaa-b12b83e4f540/resourceGroups/bgl-cor-arg-pridnsz/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"]
  }
  private_service_connection {
    name                           = format("%s-privatelink", each.value.name)
    private_connection_resource_id = each.value.id
    subresource_names              = ["blob"]
    is_manual_connection           = false  
  }

  tags = var.tags

}

resource "azurerm_private_endpoint" "storagetable" {

  for_each = {
    for key, value in azurerm_storage_account.storage :
    key => value
  }
  name                = "${each.value.name}-st"
  location            = each.value.location
  resource_group_name = data.azurerm_resource_group.this.name
  subnet_id           = data.azurerm_subnet.network.id # "/subscriptions/your-subscription-id/resourceGroups/your-network-rg/providers/Microsoft.Network/virtualNetworks/your-vnet/subnets/your-subnet"
  
  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = ["/subscriptions/979a7ec4-4c01-4027-acaa-b12b83e4f540/resourceGroups/bgl-cor-arg-pridnsz/providers/Microsoft.Network/privateDnsZones/privatelink.table.core.windows.net"]
  }
  private_service_connection {
    name                           = format("%s-privatelink", each.value.name)
    private_connection_resource_id = each.value.id
    subresource_names              = ["table"]
    is_manual_connection           = false  
  }

  tags = var.tags

}

resource "azurerm_private_endpoint" "swastorage" {

  for_each = {
    for key, value in azurerm_storage_account.swastorage :
    key => value
  }
  name                = each.value.name
  location            = each.value.location
  resource_group_name = data.azurerm_resource_group.this.name
  subnet_id           = data.azurerm_subnet.network.id # "/subscriptions/your-subscription-id/resourceGroups/your-network-rg/providers/Microsoft.Network/virtualNetworks/your-vnet/subnets/your-subnet"
  
  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = ["/subscriptions/979a7ec4-4c01-4027-acaa-b12b83e4f540/resourceGroups/bgl-cor-arg-pridnsz/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"]
  }
  private_service_connection {
    name                           = format("%s-privatelink", each.value.name)
    private_connection_resource_id = each.value.id
    subresource_names              = ["blob"]
    is_manual_connection           = false  
  }

  tags = var.tags

}

resource "azurerm_private_endpoint" "swawebstorage" {

  for_each = {
    for key, value in azurerm_storage_account.swastorage :
    key => value
  }
  name                = "${each.value.name}-web"
  location            = each.value.location
  resource_group_name = data.azurerm_resource_group.this.name
  subnet_id           = data.azurerm_subnet.network.id # "/subscriptions/your-subscription-id/resourceGroups/your-network-rg/providers/Microsoft.Network/virtualNetworks/your-vnet/subnets/your-subnet"
  
  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = ["/subscriptions/979a7ec4-4c01-4027-acaa-b12b83e4f540/resourceGroups/bgl-cor-arg-pridnsz/providers/Microsoft.Network/privateDnsZones/privatelink.azurewebsites.net"]
  }
  private_service_connection {
    name                           = format("%s-privatelink", each.value.name)
    private_connection_resource_id = each.value.id
    subresource_names              = ["web"]
    is_manual_connection           = false  
  }

  tags = var.tags
  
}

# Application Insights
resource "azurerm_application_insights" "default" {
  name                = var.appin_name
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
  application_type    = "web"

  tags = var.tags
}
