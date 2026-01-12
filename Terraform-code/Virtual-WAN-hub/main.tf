# Azure Provider Configuration
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Virtual WAN
resource "azurerm_virtual_wan" "vwan" {
  name                = var.vwan_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

# Virtual WAN Hub
resource "azurerm_virtual_hub" "hub" {
  name                = var.vhub_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  virtual_wan_id      = azurerm_virtual_wan.vwan.id
  address_prefix      = var.vhub_address_prefix
}

# Spoke VNet 1
resource "azurerm_virtual_network" "spoke1" {
  name                = var.spoke1_vnet_name
  address_space       = [var.spoke1_address_space]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "spoke1_subnet" {
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.spoke1.name
  address_prefixes     = [var.spoke1_subnet_prefix]
}

# Spoke VNet 2
resource "azurerm_virtual_network" "spoke2" {
  name                = var.spoke2_vnet_name
  address_space       = [var.spoke2_address_space]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "spoke2_subnet" {
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.spoke2.name
  address_prefixes     = [var.spoke2_subnet_prefix]
}

# Virtual Hub Connection for Spoke 1
resource "azurerm_virtual_hub_connection" "spoke1_connection" {
  name                      = "spoke1-connection"
  virtual_hub_id            = azurerm_virtual_hub.hub.id
  remote_virtual_network_id = azurerm_virtual_network.spoke1.id
}

# Virtual Hub Connection for Spoke 2
resource "azurerm_virtual_hub_connection" "spoke2_connection" {
  name                      = "spoke2-connection"
  virtual_hub_id            = azurerm_virtual_hub.hub.id
  remote_virtual_network_id = azurerm_virtual_network.spoke2.id
}

# Network Security Group for VM01
resource "azurerm_network_security_group" "nsg1" {
  name                = "vm01-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "AllowRDP"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowICMP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Icmp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Network Security Group for VM02
resource "azurerm_network_security_group" "nsg2" {
  name                = "vm02-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "AllowRDP"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowICMP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Icmp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Public IP for VM01
resource "azurerm_public_ip" "vm01_pip" {
  name                = "vm01-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Public IP for VM02
resource "azurerm_public_ip" "vm02_pip" {
  name                = "vm02-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Network Interface for VM01
resource "azurerm_network_interface" "vm01_nic" {
  name                = "vm01-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.spoke1_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm01_pip.id
  }
}

# Network Interface for VM02
resource "azurerm_network_interface" "vm02_nic" {
  name                = "vm02-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.spoke2_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm02_pip.id
  }
}

# Associate NSG with VM01 NIC
resource "azurerm_network_interface_security_group_association" "vm01_nsg_assoc" {
  network_interface_id      = azurerm_network_interface.vm01_nic.id
  network_security_group_id = azurerm_network_security_group.nsg1.id
}

# Associate NSG with VM02 NIC
resource "azurerm_network_interface_security_group_association" "vm02_nsg_assoc" {
  network_interface_id      = azurerm_network_interface.vm02_nic.id
  network_security_group_id = azurerm_network_security_group.nsg2.id
}

# Virtual Machine 01 (Spoke 1)
resource "azurerm_windows_virtual_machine" "vm01" {
  name                = var.vm01_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.vm01_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

# Virtual Machine 02 (Spoke 2)
resource "azurerm_windows_virtual_machine" "vm02" {
  name                = var.vm02_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.vm02_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}
