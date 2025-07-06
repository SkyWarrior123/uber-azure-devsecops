# Storage account for state
resource "azurerm_storage_account" "tfstate" {
  name                     = "tfstateuber"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "state" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}

# AKS cluster
module "aks" {
  source              = "Azure/aks/azurerm"
  version             = "7.0.0"
  resource_group_name = var.resource_group_name
  cluster_name        = var.cluster_name
  kubernetes_version  = var.kubernetes_version
  dns_prefix          = var.dns_prefix
  default_node_pool {
    name       = "agentpool"
    vm_size    = var.node_vm_size
    node_count = var.node_count
  }
}