# Terraform configuration to provision Azure resources (e.g., VMs, VNets, subnets, NSGs, etc.)

variable "resource_group_name" {
  type    = string
  default = "ethereum-resource-group"
}

variable "specification" {
  type    = string
  default = "low"
}

variable "key_vault_name" {
  type    = string
  default = "ethereum-key-vault"
}

# Provider Configuration
provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = "West Europe"
}

# Virtual Network
resource "azurerm_virtual_network" "example" {
  name                = "ethereum-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

# Subnet
resource "azurerm_subnet" "example" {
  name                 = "ethereum-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Network Security Group
resource "azurerm_network_security_group" "example" {
  name                = "ethereum-nsg"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    name                       = "allow_ethereum_ports"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8545-8546"
    source_address_prefixes    = ["*"]
    destination_address_prefix = azurerm_subnet.example.address_prefixes[0]
  }
}

# Network Interface
resource "azurerm_network_interface" "example" {
  name                = "ethereum-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "ethereum-ip"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Low Specification
resource "azurerm_virtual_machine" "low_spec" {
  count               = var.specification == "low" ? 1 : 0
  name                = "ethereum-node-low"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  vm_size             = "Standard_B2s"

  network_interface_ids = [azurerm_network_interface.example.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "ethereum-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }
}

# Medium Specification
resource "azurerm_virtual_machine" "medium_spec" {
  count               = var.specification == "medium" ? 1 : 0
  name                = "ethereum-node-medium"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  vm_size             = "Standard_B4ms"

  network_interface_ids = [azurerm_network_interface.example.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "ethereum-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }
}

# High Specification
resource "azurerm_virtual_machine" "high_spec" {
  count               = var.specification == "high" ? 1 : 0
  name                = "ethereum-node-high"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  vm_size             = "Standard_D4s_v3"

  network_interface_ids = [azurerm_network_interface.example.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "ethereum-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }
}

# Output variables
output "public_ip_low_spec" {
  value = azurerm_virtual_machine.low_spec[0].public_ip_address
}

output "public_ip_medium_spec" {
  value = azurerm_virtual_machine.medium_spec[0].public_ip_address
}

output "public_ip_high_spec" {
  value = azurerm_virtual_machine.high_spec[0].public_ip_address
}
