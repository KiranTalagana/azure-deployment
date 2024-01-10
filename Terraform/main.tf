# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.environment}"
  location = "eastus"
}

# Event Hub Namespace
resource "azurerm_eventhub_namespace" "evhns" {
  name                = "evhns-${var.environment}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
}

# Azure Synapse Analytics
resource "azurerm_synapse_workspace" "synapse" {
  name                                 = "synapse-${var.environment}"
  location                             = azurerm_resource_group.rg.location
  resource_group_name                  = azurerm_resource_group.rg.name
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.adls.id
  sql_administrator_login              = "sqladminuser"
  # ... other params  
}

# Function App 
resource "azurerm_function_app" "func" {
  name                       = "function-${var.environment}"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  app_service_plan_id        = azurerm_app_service_plan.asp.id
  storage_account_name       = azurerm_storage_account.sa.name
  storage_account_access_key = azurerm_storage_account.sa.primary_access_key
}