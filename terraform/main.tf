terraform {
  backend "azurerm" {
    resource_group_name  = var.tfbackend["resource_group_name"]
    storage_account_name = var.tfbackend["storage_account_name"]
    container_name       = var.tfbackend["container_name"]
    key                  = var.tfbackend["key"]
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