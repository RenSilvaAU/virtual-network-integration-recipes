# Keyvault for password
data "azurerm_key_vault" "adminpw" {
  name                = var.sql_admin_user.keyvault_name
  resource_group_name = var.sql_admin_user.keyvault_rg
}

data "azurerm_key_vault_secret" "adminpw" {
  name         = var.sql_admin_user.secret_name
  key_vault_id = data.azurerm_key_vault.adminpw.id
}

# MS SQL Server Resources
resource "azurerm_mssql_server" "this" {
  administrator_login           = var.sql_admin_user.user_name
  administrator_login_password  = data.azurerm_key_vault_secret.adminpw.value
  location                      = var.location
  name                          = var.sql_server_name
  public_network_access_enabled = false
  resource_group_name           = var.rg_name

  tags = var.tags

  version = "12.0"
  azuread_administrator {
    login_username = "juan.burckhardt@microsoft.com"
    object_id      = "c85ae29a-12ee-49ba-a3aa-f4e5ff0cc9ef"
  }
}


resource "azurerm_mssql_server_microsoft_support_auditing_policy" "this" {
  enabled                = false
  log_monitoring_enabled = false
  server_id              = azurerm_mssql_server.this.id
  depends_on = [
    azurerm_mssql_server.this,
  ]
}

resource "azurerm_mssql_server_transparent_data_encryption" "this" {
  server_id = azurerm_mssql_server.this.id
  depends_on = [
    azurerm_mssql_server.this,
  ]
}

resource "azurerm_mssql_server_extended_auditing_policy" "this" {
  enabled                = false
  log_monitoring_enabled = false
  server_id              = azurerm_mssql_server.this.id
  depends_on = [
    azurerm_mssql_server.this,
  ]
}

#resource "azurerm_mssql_server_security_alert_policy" "this" {
#  resource_group_name = var.rg_name
#  server_name         = "bgl-npe-syd-sql-svr-botpoc-01"
#  state               = "Disabled"
#  depends_on = [
#    azurerm_mssql_server.this,
#  ]
#}

#resource "azurerm_mssql_server_vulnerability_assessment" "this" {
#  server_security_alert_policy_id = "${azurerm_mssql_server.this.id}/securityAlertPolicies/Default" # "/subscriptions/31e50174-228a-451f-9eba-a903458b5fd9/resourceGroups/BGL-NPE-ARG-BOTPOCOpenAI/providers/Microsoft.Sql/servers/bgl-npe-syd-sql-svr-botpoc-01/securityAlertPolicies/Default"
#  storage_container_path          = ""
#  depends_on = [
#    azurerm_mssql_server_security_alert_policy.this,
#  ]
#}

#resource "azurerm_sql_active_directory_administrator" "res-47" {
#  login               = "juan.burckhardt@microsoft.com"
#  object_id           = "c85ae29a-12ee-49ba-a3aa-f4e5ff0cc9ef"
#  resource_group_name = var.rg_name
#  server_name         = azurerm_mssql_server.this.name
#  tenant_id           = "d92123ce-0eea-489a-85ca-bb4e3dc51e8d"
#  depends_on = [
#    azurerm_mssql_server.this,
#  ]
#}

# SQL Database
resource "azurerm_mssql_database" "this" {
  name      = var.sql_db_name
  server_id = azurerm_mssql_server.this.id

  tags = var.tags

  depends_on = [
    azurerm_mssql_server.this,
  ]
}

#resource "azurerm_mssql_database_extended_auditing_policy" "master" {
#  database_id            = "${azurerm_mssql_server.this.id}/databases/master"
#  enabled                = false
#  log_monitoring_enabled = false
#}
#
#
#resource "azurerm_mssql_database_extended_auditing_policy" "this" {
#  database_id            = azurerm_mssql_database.this.id # "/subscriptions/31e50174-228a-451f-9eba-a903458b5fd9/resourceGroups/BGL-NPE-ARG-BOTPOCOpenAI/providers/Microsoft.Sql/servers/bgl-npe-syd-sql-svr-botpoc-01/databases/npebotpoc-teamassist"
#  enabled                = false
#  log_monitoring_enabled = false
#  depends_on = [
#    azurerm_mssql_database.this,
#  ]
#}


resource "azurerm_private_endpoint" "this" {
  custom_network_interface_name = "${var.sql_server_name}-nic"
  location                      = var.location
  name                          = "${var.sql_server_name}-nic"
  resource_group_name           = var.rg_name
  subnet_id                     = data.azurerm_subnet.network.id # "/subscriptions/31e50174-228a-451f-9eba-a903458b5fd9/resourceGroups/BGL-NPE-ARG-Network/providers/Microsoft.Network/virtualNetworks/BGL-SYD-NPE-DEV-VNT-10.4.64.0/subnets/BGL-SYD-NPE-DEV-SUB-PEP-01"

  tags = var.tags

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = ["/subscriptions/979a7ec4-4c01-4027-acaa-b12b83e4f540/resourceGroups/BGL-COR-ARG-PriDNSZ/providers/Microsoft.Network/privateDnsZones/privatelink.database.windows.net"]
  }
  private_service_connection {
    is_manual_connection           = false
    name                           = "${var.sql_server_name}-nic"
    private_connection_resource_id = azurerm_mssql_server.this.id
    subresource_names              = ["sqlServer"]
  }
  depends_on = [
    azurerm_mssql_server.this,
  ]
}
