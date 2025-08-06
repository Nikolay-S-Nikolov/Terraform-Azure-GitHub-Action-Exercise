provider "azurerm" {
  features {}

}


resource "azurerm_resource_group" "tfstate" {
  name     = "tfstate-rg"
  location = "west europe"
}

resource "azurerm_storage_account" "tfstateac" {
  name                     = "tfstateniko"
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstatecontainer"
  storage_account_id = azurerm_storage_account.tfstateac.id
  # Ensure the container is private
  container_access_type = "private"
}