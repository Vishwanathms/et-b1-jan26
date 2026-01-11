variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "hub_vnet_name" {
  description = "Name of the Hub VNet"
  type        = string
}

variable "hub_vnet_address_space" {
  description = "Address space for Hub VNet"
  type        = list(string)
}

variable "spoke1_vnet_name" {
  description = "Name of the Spoke1 VNet"
  type        = string
}

variable "spoke1_vnet_address_space" {
  description = "Address space for Spoke1 VNet"
  type        = list(string)
}

variable "spoke1_subnet_name" {
  description = "Name of the Spoke1 subnet"
  type        = string
}

variable "spoke1_subnet_address_prefix" {
  description = "Address prefix for Spoke1 subnet"
  type        = list(string)
}

variable "spoke2_vnet_name" {
  description = "Name of the Spoke2 VNet"
  type        = string
}

variable "spoke2_vnet_address_space" {
  description = "Address space for Spoke2 VNet"
  type        = list(string)
}

variable "spoke2_subnet_name" {
  description = "Name of the Spoke2 subnet"
  type        = string
}

variable "spoke2_subnet_address_prefix" {
  description = "Address prefix for Spoke2 subnet"
  type        = list(string)
}

variable "vm01_name" {
  description = "Name of VM01"
  type        = string
}

variable "vm02_name" {
  description = "Name of VM02"
  type        = string
}

variable "vm_size" {
  description = "Size of the virtual machines"
  type        = string
}

variable "admin_username" {
  description = "Admin username for VMs"
  type        = string
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key"
  type        = string
}
