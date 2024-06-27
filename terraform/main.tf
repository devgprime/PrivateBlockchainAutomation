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

variable "admin_username" {
  type    = string
  default = "adminuser"
}

variable "admin_password" {
  type    = string
}

# Provider Configuration
provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = "West Europe"
  tags = {
    environment = "dev"
  }
}

# Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = "ethereum-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags = {
    environment = "dev"
  }
}

# Subnet
resource "azurerm_subnet" "main" {
  name                 = "ethereum-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Network Security Group
resource "azurerm_network_security_group" "main" {
  name                = "ethereum-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "allow_ethereum_ports"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8545-8546"
    source_address_prefixes    = ["*"]
    destination_address_prefix = azurerm_subnet.main.address_prefixes[0]
  }

  tags = {
    environment = "dev"
  }
}

# Network Interface
resource "azurerm_network_interface" "main" {
  name                = "ethereum-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "ethereum-ip"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = "dev"
  }
}

locals {
  vm_base = {
    location            = azurerm_resource_group.main.location
    resource_group_name = azurerm_resource_group.main.name
    network_interface_ids = [azurerm_network_interface.main.id]
    admin_username      = var.admin_username
    admin_password      = var.admin_password
    storage_image_reference = {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "18.04-LTS"
      version   = "latest"
    }
    storage_os_disk = {
      name              = "ethereum-osdisk"
      caching           = "ReadWrite"
      create_option     = "FromImage"
      managed_disk_type = "Premium_LRS"
    }
  }
}

# Low Specification VM
resource "azurerm_virtual_machine" "low_spec" {
  count               = var.specification == "low" ? 1 : 0
  name                = "ethereum-node-low"
  location            = local.vm_base.location
  resource_group_name = local.vm_base.resource_group_name
  network_interface_ids = local.vm_base.network_interface_ids
  vm_size             = "Standard_B2s"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  storage_image_reference = local.vm_base.storage_image_reference
  storage_os_disk         = local.vm_base.storage_os_disk

  os_profile {
    computer_name  = "ethereum-node-low"
    admin_username = local.vm_base.admin_username
    admin_password = local.vm_base.admin_password
  }

  tags = {
    environment = "dev"
  }
}

# Medium Specification VM
resource "azurerm_virtual_machine" "medium_spec" {
  count               = var.specification == "medium" ? 1 : 0
  name                = "ethereum-node-medium"
  location            = local.vm_base.location
  resource_group_name = local.vm_base.resource_group_name
  network_interface_ids = local.vm_base.network_interface_ids
  vm_size             = "Standard_B4ms"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  storage_image_reference = local.vm_base.storage_image_reference
  storage_os_disk         = local.vm_base.storage_os_disk

  os_profile {
    computer_name  = "ethereum-node-medium"
    admin_username = local.vm_base.admin_username
    admin_password = local.vm_base.admin_password
  }

  tags = {
    environment = "dev"
  }
}

# High Specification VM
resource "azurerm_virtual_machine" "high_spec" {
  count               = var.specification == "high" ? 1 : 0
  name                = "ethereum-node-high"
  location            = local.vm_base.location
  resource_group_name = local.vm_base.resource_group_name
  network_interface_ids = local.vm_base.network_interface_ids
  vm_size             = "Standard_D4s_v3"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  storage_image_reference = local.vm_base.storage_image_reference
  storage_os_disk         = local.vm_base.storage_os_disk

  os_profile {
    computer_name  = "ethereum-node-high"
    admin_username = local.vm_base.admin_username
    admin_password = local.vm_base.admin_password
  }

  tags = {
    environment = "dev"
  }
}

# Output variables
output "public_ip_low_spec" {
  value = azurerm_virtual_machine.low_spec[0].public_ip_address
  condition = var.specification == "low"
}

output "public_ip_medium_spec" {
  value = azurerm_virtual_machine.medium_spec[0].public_ip_address
  condition = var.specification == "medium"
}

output "public_ip_high_spec" {
  value = azurerm_virtual_machine.high_spec[0].public_ip_address
  condition = var.specification == "high"
}
