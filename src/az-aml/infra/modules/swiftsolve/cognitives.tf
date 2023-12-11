# Open AI
resource "random_string" "ci_prefix" {
  length  = 1
  upper   = false
  special = false
  numeric = false
}

resource "azurerm_cognitive_account" "openai" {
  custom_subdomain_name         = var.openai_account
  kind                          = "OpenAI"
  location                      = "eastus"
  name                          = var.openai_account
  public_network_access_enabled = false
  resource_group_name           = var.rg_name
  sku_name                      = "S0"
  
  tags = var.tags
  network_acls {
    default_action = "Allow"
    ip_rules       = ["147.161.218.167", "147.161.218.199", "165.225.232.190"]
  }

}
resource "azurerm_cognitive_deployment" "gpt-35-turbo" {
  cognitive_account_id = azurerm_cognitive_account.openai.id # "/subscriptions/31e50174-228a-451f-9eba-a903458b5fd9/resourceGroups/BGL-NPE-ARG-BOTPOCOpenAI/providers/Microsoft.CognitiveServices/accounts/bglnpeopenaibotpoc01"
  name                 = "gpt-35-turbo"
  rai_policy_name      = "Microsoft.Default"
  model {
    format  = "OpenAI"
    name    = "gpt-35-turbo"
    version = "0613"
  }
  scale {
    capacity = 120
    type     = "Standard"
  }
  depends_on = [
    azurerm_cognitive_account.openai,
  ]
}
resource "azurerm_cognitive_deployment" "gpt-35-turbo-16k" {
  cognitive_account_id = azurerm_cognitive_account.openai.id # "/subscriptions/31e50174-228a-451f-9eba-a903458b5fd9/resourceGroups/BGL-NPE-ARG-BOTPOCOpenAI/providers/Microsoft.CognitiveServices/accounts/bglnpeopenaibotpoc01"
  name                 = "gpt-35-turbo-16k"
  rai_policy_name      = "Microsoft.Default"
  model {
    format  = "OpenAI"
    name    = "gpt-35-turbo-16k"
    version = "0613"
  }
  scale {
    capacity = 120
    type     = "Standard"
  }
  depends_on = [
    azurerm_cognitive_account.openai,
  ]
}
resource "azurerm_cognitive_deployment" "text-embedding-ada-002" {
  cognitive_account_id = azurerm_cognitive_account.openai.id # "/subscriptions/31e50174-228a-451f-9eba-a903458b5fd9/resourceGroups/BGL-NPE-ARG-BOTPOCOpenAI/providers/Microsoft.CognitiveServices/accounts/bglnpeopenaibotpoc01"
  name                 = "text-embedding-ada-002"
  rai_policy_name      = "Microsoft.Default"
  model {
    format  = "OpenAI"
    name    = "text-embedding-ada-002"
    version = "2"
  }
  scale {
    capacity = 120
    type     = "Standard"
  }
  depends_on = [
    azurerm_cognitive_account.openai,
  ]
}

resource "azurerm_private_endpoint" "openai" {
  custom_network_interface_name = "${var.openai_account}-pep-nic" #"bglnpeopenaibotpoc01-pep-nic"
  location                      = "australiaeast"
  name                          = "${var.openai_account}-pep-nic"
  resource_group_name           = var.rg_name
  subnet_id                     = data.azurerm_subnet.network.id #"/subscriptions/31e50174-228a-451f-9eba-a903458b5fd9/resourceGroups/BGL-NPE-ARG-Network/providers/Microsoft.Network/virtualNetworks/BGL-SYD-NPE-DEV-VNT-10.4.64.0/subnets/BGL-SYD-NPE-DEV-SUB-PEP-01"
  tags = var.tags
  
  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = ["/subscriptions/979a7ec4-4c01-4027-acaa-b12b83e4f540/resourceGroups/bgl-cor-arg-pridnsz/providers/Microsoft.Network/privateDnsZones/privatelink.openai.azure.com"]
  }
  private_service_connection {
    is_manual_connection           = false
    name                           = "${var.openai_account}-pep" #"bglnpeopenaibotpoc01-pep"
    private_connection_resource_id = azurerm_cognitive_account.openai.id #"/subscriptions/31e50174-228a-451f-9eba-a903458b5fd9/resourceGroups/BGL-NPE-ARG-BOTPOCOpenAI/providers/Microsoft.CognitiveServices/accounts/bglnpeopenaibotpoc01"
    subresource_names              = ["account"]
  }
  depends_on = [
    azurerm_cognitive_account.openai,
  ]
}

# Cognitive Services 
resource "azurerm_cognitive_account" "cogservices" {
  custom_subdomain_name = var.cog_account #"bglnpecogsearchbotpoc"
  kind                  = "CognitiveServices"
  location              = "eastus"
  name                  = var.cog_account #"bglnpesearchbotpoc"
  resource_group_name   = var.rg_name
  sku_name              = "S0"
  tags = var.tags
  network_acls {
    default_action = "Deny"
    ip_rules       = ["147.161.218.167", "147.161.218.199", "165.225.232.190"]
  }

}
resource "azurerm_private_endpoint" "cogservices" {
  custom_network_interface_name = "${var.cog_account}-pep-nic" #"bglnpecogsearchbotpoc-pep-nic"
  location                      = "australiaeast"
  name                          = "${var.cog_account}-pep-nic"
  resource_group_name           = var.rg_name #"BGL-NPE-ARG-BOTPOCOpenAI"
  subnet_id                     = data.azurerm_subnet.network.id #"/subscriptions/31e50174-228a-451f-9eba-a903458b5fd9/resourceGroups/BGL-NPE-ARG-Network/providers/Microsoft.Network/virtualNetworks/BGL-SYD-NPE-DEV-VNT-10.4.64.0/subnets/BGL-SYD-NPE-DEV-SUB-PEP-01"
  tags = var.tags

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = ["/subscriptions/979a7ec4-4c01-4027-acaa-b12b83e4f540/resourceGroups/BGL-COR-ARG-PriDNSZ/providers/Microsoft.Network/privateDnsZones/privatelink.cognitiveservices.azure.com"]
  }
  private_service_connection {
    is_manual_connection           = false
    name                           = "${var.cog_account}-pep" #"bglnpecogsearchbotpoc-pep"
    private_connection_resource_id = azurerm_cognitive_account.cogservices.id # "/subscriptions/31e50174-228a-451f-9eba-a903458b5fd9/resourceGroups/BGL-NPE-ARG-BOTPOCOpenAI/providers/Microsoft.CognitiveServices/accounts/bglnpesearchbotpoc"
    subresource_names              = ["account"]
  }
  depends_on = [
    azurerm_cognitive_account.cogservices,
  ]
}


# Cognitive Services Australia East (for speech to text)
resource "azurerm_cognitive_account" "cogservices-ae" {
  custom_subdomain_name = var.cog_account_ae #"bglnpecogsearchbotpoc"
  kind                  = "CognitiveServices"
  location              = "australiaeast"
  name                  = var.cog_account_ae #"bglnpesearchbotpoc"
  resource_group_name   = var.rg_name
  sku_name              = "S0"
  tags = var.tags
  network_acls {
    default_action = "Deny"
    ip_rules       = ["147.161.218.167", "147.161.218.199", "165.225.232.190"]
  }

}
resource "azurerm_private_endpoint" "cogservices-ae" {
  custom_network_interface_name = "${var.cog_account_ae}-pep-nic" #"bglnpecogsearchbotpoc-pep-nic"
  location                      = "australiaeast"
  name                          = "${var.cog_account_ae}-pep-nic"
  resource_group_name           = var.rg_name #"BGL-NPE-ARG-BOTPOCOpenAI"
  subnet_id                     = data.azurerm_subnet.network.id #"/subscriptions/31e50174-228a-451f-9eba-a903458b5fd9/resourceGroups/BGL-NPE-ARG-Network/providers/Microsoft.Network/virtualNetworks/BGL-SYD-NPE-DEV-VNT-10.4.64.0/subnets/BGL-SYD-NPE-DEV-SUB-PEP-01"
  tags = var.tags

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = ["/subscriptions/979a7ec4-4c01-4027-acaa-b12b83e4f540/resourceGroups/BGL-COR-ARG-PriDNSZ/providers/Microsoft.Network/privateDnsZones/privatelink.cognitiveservices.azure.com"]
  }
  private_service_connection {
    is_manual_connection           = false
    name                           = "${var.cog_account_ae}-pep" #"bglnpecogsearchbotpoc-pep"
    private_connection_resource_id = azurerm_cognitive_account.cogservices-ae.id # "/subscriptions/31e50174-228a-451f-9eba-a903458b5fd9/resourceGroups/BGL-NPE-ARG-BOTPOCOpenAI/providers/Microsoft.CognitiveServices/accounts/bglnpesearchbotpoc"
    subresource_names              = ["account"]
  }
  depends_on = [
    azurerm_cognitive_account.cogservices-ae,
  ]
}

# Azure Search Service 

resource "azurerm_search_service" "azsearch" {
  allowed_ips                   = ["147.161.218.167", "147.161.218.199", "165.225.232.190"]
  location                      = "eastus"
  name                          = var.az_search
  public_network_access_enabled = false
  resource_group_name           = var.rg_name
  sku                           = "standard2"
  tags = var.tags 

  identity {
    type = "SystemAssigned"
  }

}

resource "azurerm_private_endpoint" "azsearch" {
  location            = "australiaeast"
  name                = "${var.az_search}-pep"
  resource_group_name = var.rg_name
  subnet_id           = data.azurerm_subnet.network.id #"/subscriptions/31e50174-228a-451f-9eba-a903458b5fd9/resourceGroups/BGL-NPE-ARG-Network/providers/Microsoft.Network/virtualNetworks/BGL-SYD-NPE-DEV-VNT-10.4.64.0/subnets/BGL-SYD-NPE-DEV-SUB-PEP-01"
  tags = var.tags

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = ["/subscriptions/979a7ec4-4c01-4027-acaa-b12b83e4f540/resourceGroups/bgl-cor-arg-pridnsz/providers/Microsoft.Network/privateDnsZones/privatelink.search.windows.net"]
  }
  private_service_connection {
    is_manual_connection           = false
    name                           = "${var.az_search}-pep" #"bglnpesearchbotpoc01-pep_037bea30-3148-49e2-a44a-071d9a77401c"
    private_connection_resource_id = azurerm_search_service.azsearch.id # "/subscriptions/31e50174-228a-451f-9eba-a903458b5fd9/resourcegroups/BGL-NPE-ARG-BOTPOCOpenAI/providers/Microsoft.Search/searchServices/bglnpesearchbotpoc01"
    subresource_names              = ["searchService"]
  }

}

resource "azurerm_search_shared_private_link_service" "azsearch" {
  for_each = {
    for key, value in azurerm_storage_account.storage :
    key => value
  }
  name               = "${var.az_search}-spa-${random_string.ci_prefix.result}" # "bglnpesearchbotpoc01-spa"
  request_message    = "Please approve"
  search_service_id  = azurerm_search_service.azsearch.id #"/subscriptions/31e50174-228a-451f-9eba-a903458b5fd9/resourceGroups/BGL-NPE-ARG-BOTPOCOpenAI/providers/Microsoft.Search/searchServices/bglnpesearchbotpoc01"
  subresource_name   = "blob"
  target_resource_id = each.value.id #azurerm_storage_account.storage.id # "/subscriptions/31e50174-228a-451f-9eba-a903458b5fd9/resourceGroups/BGL-NPE-ARG-BOTPOCOpenAI/providers/Microsoft.Storage/storageAccounts/bglnpestabotpoc"
  depends_on = [
    azurerm_search_service.azsearch,
    azurerm_storage_account.storage,
  ]
}


#resource "azurerm_private_endpoint" "res-31" {
#  custom_network_interface_name = "bglnpeazsearchbotpoc-pep-nic"
#  location                      = "australiaeast"
#  name                          = "bglnpeazsearchbotpoc-pep"
#  resource_group_name           = "BGL-NPE-ARG-BOTPOCOpenAI"
#  subnet_id                     = "/subscriptions/31e50174-228a-451f-9eba-a903458b5fd9/resourceGroups/BGL-NPE-ARG-Network/providers/Microsoft.Network/virtualNetworks/BGL-SYD-NPE-DEV-VNT-10.4.64.0/subnets/BGL-SYD-NPE-DEV-SUB-PEP-01"
#  tags = {
#    CostCenter  = "1780"
#    Environment = "PROD"
#    Owner       = "BGLTechInfra"
#  }
#  private_dns_zone_group {
#    name                 = "default"
#    private_dns_zone_ids = ["/subscriptions/979a7ec4-4c01-4027-acaa-b12b83e4f540/resourceGroups/bgl-cor-arg-pridnsz/providers/Microsoft.Network/privateDnsZones/privatelink.search.windows.net"]
#  }
#  private_service_connection {
#    is_manual_connection           = false
#    name                           = "bglnpeazsearchbotpoc-pep"
#    private_connection_resource_id = "/subscriptions/31e50174-228a-451f-9eba-a903458b5fd9/resourceGroups/BGL-NPE-ARG-BOTPOCOpenAI/providers/Microsoft.Search/searchServices/bglnpeazsearchbotpoc"
#    subresource_names              = ["searchService"]
#  }
#
#}
#resource "azurerm_private_endpoint" "res-33" {
#  custom_network_interface_name = "bglnpecogsearchbotpoc-pep-nic"
#  location                      = "australiaeast"
#  name                          = "bglnpecogsearchbotpoc-pep"
#  resource_group_name           = "BGL-NPE-ARG-BOTPOCOpenAI"
#  subnet_id                     = "/subscriptions/31e50174-228a-451f-9eba-a903458b5fd9/resourceGroups/BGL-NPE-ARG-Network/providers/Microsoft.Network/virtualNetworks/BGL-SYD-NPE-DEV-VNT-10.4.64.0/subnets/BGL-SYD-NPE-DEV-SUB-PEP-01"
#  tags = {
#    CostCenter  = "1090"
#    Environment = "NPE"
#    Owner       = "BGLBusinessImprv"
#  }
#  private_dns_zone_group {
#    name                 = "default"
#    private_dns_zone_ids = ["/subscriptions/979a7ec4-4c01-4027-acaa-b12b83e4f540/resourceGroups/BGL-COR-ARG-PriDNSZ/providers/Microsoft.Network/privateDnsZones/privatelink.cognitiveservices.azure.com"]
#  }
#  private_service_connection {
#    is_manual_connection           = false
#    name                           = "bglnpecogsearchbotpoc-pep"
#    private_connection_resource_id = "/subscriptions/31e50174-228a-451f-9eba-a903458b5fd9/resourceGroups/BGL-NPE-ARG-BOTPOCOpenAI/providers/Microsoft.CognitiveServices/accounts/bglnpesearchbotpoc"
#    subresource_names              = ["account"]
#  }
#  depends_on = [
#    azurerm_cognitive_account.cogservices,
#  ]
#}
#resource "azurerm_private_endpoint" "res-35" {
#  custom_network_interface_name = "bglnpeopenaibotpoc01-pep-nic"
#  location                      = "australiaeast"
#  name                          = "bglnpeopenaibotpoc01-pep"
#  resource_group_name           = "BGL-NPE-ARG-BOTPOCOpenAI"
#  subnet_id                     = "/subscriptions/31e50174-228a-451f-9eba-a903458b5fd9/resourceGroups/BGL-NPE-ARG-Network/providers/Microsoft.Network/virtualNetworks/BGL-SYD-NPE-DEV-VNT-10.4.64.0/subnets/BGL-SYD-NPE-DEV-SUB-PEP-01"
#  tags = {
#    CostCenter  = "1090"
#    Environment = "NPE"
#    Owner       = "BGLBusinessImprv"
#  }
#  private_dns_zone_group {
#    name                 = "default"
#    private_dns_zone_ids = ["/subscriptions/979a7ec4-4c01-4027-acaa-b12b83e4f540/resourceGroups/bgl-cor-arg-pridnsz/providers/Microsoft.Network/privateDnsZones/privatelink.openai.azure.com"]
#  }
#  private_service_connection {
#    is_manual_connection           = false
#    name                           = "bglnpeopenaibotpoc01-pep"
#    private_connection_resource_id = "/subscriptions/31e50174-228a-451f-9eba-a903458b5fd9/resourceGroups/BGL-NPE-ARG-BOTPOCOpenAI/providers/Microsoft.CognitiveServices/accounts/bglnpeopenaibotpoc01"
#    subresource_names              = ["account"]
#  }
#  depends_on = [
#    azurerm_cognitive_account.openai,
#  ]
#}