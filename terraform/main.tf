terraform {
  backend "azurerm" {
    resource_group_name  = "m11hghtftestrg"
    storage_account_name = "m11hghtftest"
    container_name       = "m11hghtftesttfstate"
    key                  = "m11hghtftesttfstate.tfstate"
  }
}

provider "azurerm" {
  # The "feature" block is required for AzureRM provider 2.x.
  # If you're using version 1.x, the "features" block is not allowed.
  version = "~>2.0"
  features {}
}

data "azurerm_client_config" "current" {}

#Create Resource Group
resource "azurerm_resource_group" "main_rg" {
  name     = "${var.project_name}${var.abbreviations["resource_group"]}"
  location = var.azure_region["primary"]
}