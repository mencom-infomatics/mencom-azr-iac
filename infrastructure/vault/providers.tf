terraform {
  required_version = ">= 1.12.1"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.32.0"
    }
  }
  backend "azurerm" {}
}

provider "azurerm" {
  use_oidc = true
  use_msi  = true
  features {}
}
