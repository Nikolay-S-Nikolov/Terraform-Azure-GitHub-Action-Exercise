terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.38.1"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "b0d9c329-7449-4b76-8026-06ebed4260bc"
}

resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

resource "azurerm_resource_group" "azrg" {
  name     = "${var.resource_group_name}${random_integer.ri.result}"
  location = var.resource_group_location
}

resource "azurerm_service_plan" "azsp" {
  name                = "${var.app_service_plan_name}${random_integer.ri.result}"
  resource_group_name = azurerm_resource_group.azrg.name
  location            = azurerm_resource_group.azrg.location
  os_type             = "Linux"
  sku_name            = "F1"
}

resource "azurerm_linux_web_app" "azlwa" {
  name                = "${var.app_service_name}${random_integer.ri.result}"
  resource_group_name = azurerm_resource_group.azrg.name
  location            = azurerm_service_plan.azsp.location
  service_plan_id     = azurerm_service_plan.azsp.id

  site_config {
    application_stack {
      dotnet_version = "6.0"
    }
    always_on = false
  }

  connection_string {
    name  = "DefaultConnection"
    type  = "SQLAzure"
    value = "Data Source=tcp:${azurerm_mssql_server.azsqlserver.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.azsqldb.name};User ID=${azurerm_mssql_server.azsqlserver.administrator_login};Password=${azurerm_mssql_server.azsqlserver.administrator_login_password};Trusted_Connection=False; MultipleActiveResultSets=True;"
  }
}

resource "azurerm_app_service_source_control" "azassc" {
  app_id   = azurerm_linux_web_app.azlwa.id
  repo_url = var.repo_url
  branch   = "main"
}

resource "azurerm_mssql_server" "azsqlserver" {
  name                         = "${var.sql_server_name}${random_integer.ri.result}"
  resource_group_name          = azurerm_resource_group.azrg.name
  location                     = azurerm_resource_group.azrg.location
  version                      = "12.0"
  administrator_login          = var.sql_administrator_login_username
  administrator_login_password = var.sql_administrator_login_password
}

resource "azurerm_mssql_firewall_rule" "firewall" {
  name             = var.firewall_rule_name
  server_id        = azurerm_mssql_server.azsqlserver.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_mssql_database" "azsqldb" {
  name           = "${var.sql_database_name}${random_integer.ri.result}"
  server_id      = azurerm_mssql_server.azsqlserver.id
  max_size_gb    = 2
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  sku_name       = "S0"
  zone_redundant = false
}
