variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where the resources will be created in Azure."
}

variable "resource_group_location" {
  type        = string
  description = "The Azure region where the resource group will be located."
}

variable "app_service_plan_name" {
  type        = string
  description = "The name of the App Service plan that will host the web application."
}

variable "app_service_name" {
  type        = string
  description = "The name of the App Service that will host the web application."
}

variable "sql_server_name" {
  type        = string
  description = "The name of the SQL server that will host the database."
}

variable "sql_database_name" {
  type        = string
  description = "The name of the SQL database that will be created on the SQL server."
}

variable "sql_administrator_login_username" {
  type        = string
  description = "The username for the SQL administrator login."
}

variable "sql_administrator_login_password" {
  type        = string
  description = "The password for the SQL administrator login."
  sensitive   = true
}

variable "firewall_rule_name" {
  type        = string
  description = "The name of the firewall rule that allows access to the SQL server from the App Service."
}

variable "repo_url" {
  type        = string
  description = "The URL of the Git repository where the web application code is stored."

}