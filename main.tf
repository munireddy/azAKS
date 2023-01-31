apiVersion: apps/v1
kind: Deployment
metadata:
  name: azaks-kubernetes
spec:
  selector:
    matchLabels:
      name: azaks-kubernetes
  template:
    metadata:
      labels:
        name: azaks-kubernetes
    spec:
      containers:
        - name: app
          image: municontainers.azurecr.io/henry:v1
          ports:
            - containerPort: 8080
henry [ ~/aks/azAKS ]$ cat maint.tf 
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


#resource "azurerm_resource_group" "rg" {
#  name     = "Azure_subscription_2"
#  location = "EastUS2"
#}


resource "azurerm_kubernetes_cluster" "cluster" {
  name                = "azakscluster02"
  location            = "EastUS2"
  resource_group_name = "Azure_subscription_2"
  dns_prefix          = "azakscluster02"
  #acr_id =  "/subscriptions/5c83ae61-fc48-444f-ac18-0c228f6f1950/resourceGroups/Azure_subscription_2/providers/Microsoft.ContainerRegistry/registries/municontainers"
  default_node_pool {
    name       = "default"
    node_count = "1"
    vm_size    = "standard_d2_v2"
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "ra" {
  principal_id                     =  azurerm_kubernetes_cluster.cluster.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = "/subscriptions/5c83ae61-fc48-444f-ac18-0c228f6f1950/resourceGroups/Azure_subscription_2/providers/Microsoft.ContainerRegistry/registries/municontainers"
  skip_service_principal_aad_check = true
}

resource "null_resource" "default" {
  provisioner "local-exec" {
    command = "echo 'Sample to test Terraform on Azure'"
  }
}
