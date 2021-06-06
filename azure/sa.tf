resource "azurerm_storage_account" "davestorageaccounttf" {
  name                = "davestorageaccounttf"
  resource_group_name = azurerm_resource_group.daveterraformgroup.name

  location                 = "westeurope"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  network_rules {
    default_action             = "Deny"
    ip_rules                   = ["100.0.0.1"]
    virtual_network_subnet_ids = [azurerm_subnet.daveterraformsubnet.id]
    bypass                     = ["Metrics", "AzureServices"]
  }

  tags = {
    environment = "staging"
  }
}


