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


resource "azurerm_kubernetes_cluster" "cluster" {
  name                = "azakscluster01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "azakscluster01"

  default_node_pool {
    name       = "default"
    node_count = "3"
    vm_size    = "standard_d2_v2"
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "null_resource" "default" {
  provisioner "local-exec" {
    command = "echo 'Sample to test Terraform on Azure'"
  }
}
