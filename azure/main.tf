provider "azurerm" {
    # The "feature" block is required for AzureRM provider 2.x.
    # If you're using version 1.x, the "features" block is not allowed.
  features {}
}

resource "azurerm_resource_group" "daveterraformgroup" {
    name     = "rg-dave-terraform-test"
    location = "westeurope"

    tags = {
        environment = "Terraform Demo"
    }
}

# Create virtual network
resource "azurerm_virtual_network" "daveterraformnetwork" {
    name                = "daveVnet"
    address_space       = ["10.0.0.0/16"]
    location            = "westeurope"
    resource_group_name = azurerm_resource_group.daveterraformgroup.name

    tags = {
        environment = "Terraform Demo"
    }
}

# Create subnet
resource "azurerm_subnet" "daveterraformsubnet" {
    name                 = "daveSubnet"
    resource_group_name  = azurerm_resource_group.daveterraformgroup.name
    virtual_network_name = azurerm_virtual_network.daveterraformnetwork.name
    address_prefixes       = ["10.0.1.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "daveterraformpublicip" {
    name                         = "davePublicIP"
    location                     = "westeurope"
    resource_group_name          = azurerm_resource_group.daveterraformgroup.name
    allocation_method            = "Dynamic"

    tags = {
        environment = "Terraform Demo"
    }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "daveterraformnsg" {
    name                = "daveNetworkSecurityGroup"
    location            = "westeurope"
    resource_group_name = azurerm_resource_group.daveterraformgroup.name
    
    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = {
        environment = "Terraform Demo"
    }
}

# Create network interface
resource "azurerm_network_interface" "daveterraformnic" {
    name                      = "daveNIC"
    location                  = "westeurope"
    resource_group_name       = azurerm_resource_group.daveterraformgroup.name

    ip_configuration {
        name                          = "daveNicConfiguration"
        subnet_id                     = azurerm_subnet.daveterraformsubnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.daveterraformpublicip.id
    }

    tags = {
        environment = "Terraform Demo"
    }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "dave" {
    network_interface_id      = azurerm_network_interface.daveterraformnic.id
    network_security_group_id = azurerm_network_security_group.daveterraformnsg.id
}


resource "azurerm_linux_virtual_machine" "daveterraformvm" {
  name                            = "dave_terraform_test"
  resource_group_name             = azurerm_resource_group.daveterraformgroup.name
  location                        = "westeurope"
  size                            = "Standard_DS3_v2"
  admin_username                  = "centos"
  network_interface_ids = [
    azurerm_network_interface.daveterraformnic.id,
  ]

  admin_ssh_key {
    username = "centos"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "Centos"
    sku       = "8_2"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Premium_LRS"
    caching              = "ReadWrite"
  }
}

