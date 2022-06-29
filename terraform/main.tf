terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "m11hghtftestrg"
    storage_account_name = "m11hghtftest"
    container_name       = "m11hghtftesttfstate"
    key                  = "m11hghtftesttfstate.tfstate"
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

#Create Resource Group
resource "azurerm_resource_group" "main_rg" {
  name     = "${var.project_name}${var.abbreviations["resource_group"]}"
  location = var.azure_region["primary"]
}