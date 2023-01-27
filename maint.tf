terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.48.0"
    }
  }
}

provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "rg" {
  name     = "Azure_subscription_2"
  location = "EastUS2"
}

resource "null_resource" "default" {
  provisioner "local-exec" {
    command = "echo 'Sample to test Terraform on Azure'"
  }
}
