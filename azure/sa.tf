resource "azurerm_storage_account" "davestorageaccounttf" {
  name                = "davestorageaccounttf"
  resource_group_name = azurerm_resource_group.daveterraformgroup.name

  location                 = "westeurope"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  access_tier               = "Hot"
  allow_blob_public_access  = true
  enable_https_traffic_only = true

  network_rules {
    default_action             = "Allow"
    ip_rules                   = ["<MY-OWN-IP-ADDRESS"]
    virtual_network_subnet_ids = [azurerm_subnet.daveterraformsubnet.id]
    bypass                     = ["Metrics", "AzureServices"]
  }

  tags = {
    environment = "staging"
  }
}

resource "azurerm_storage_container" "davecontainer" {
  name                  = "davecontainer"
  storage_account_name  = azurerm_storage_account.davestorageaccounttf.name
  container_access_type = "blob"
}
