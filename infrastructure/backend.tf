terraform {
  backend "azurerm" {
    resource_group_name  = "rg-uber-clone"
    storage_account_name = "tfstateuber"
    container_name       = "tfstate"
    key                  = "aks_terraform.tfstate"
  }
  required_providers {
    azurerm = { source = "hashicorp/azurerm" version = "~> 3.0" }
  }
}

provider "azurerm" {
  features {}
}