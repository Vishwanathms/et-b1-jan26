variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-vwan-demo"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "East US"
}

variable "vwan_name" {
  description = "Name of the Virtual WAN"
  type        = string
  default     = "vwan-demo"
}

variable "vhub_name" {
  description = "Name of the Virtual Hub"
  type        = string
  default     = "vhub-demo"
}

variable "vhub_address_prefix" {
  description = "Address prefix for the Virtual Hub"
  type        = string
  default     = "10.0.0.0/24"
}

variable "spoke1_vnet_name" {
  description = "Name of Spoke VNet 1"
  type        = string
  default     = "vnet-spoke1"
}

variable "spoke1_address_space" {
  description = "Address space for Spoke VNet 1"
  type        = string
  default     = "10.1.0.0/16"
}

variable "spoke1_subnet_prefix" {
  description = "Subnet prefix for Spoke VNet 1"
  type        = string
  default     = "10.1.1.0/24"
}

variable "spoke2_vnet_name" {
  description = "Name of Spoke VNet 2"
  type        = string
  default     = "vnet-spoke2"
}

variable "spoke2_address_space" {
  description = "Address space for Spoke VNet 2"
  type        = string
  default     = "10.2.0.0/16"
}

variable "spoke2_subnet_prefix" {
  description = "Subnet prefix for Spoke VNet 2"
  type        = string
  default     = "10.2.1.0/24"
}

variable "vm01_name" {
  description = "Name of VM01"
  type        = string
  default     = "vm01"
}

variable "vm02_name" {
  description = "Name of VM02"
  type        = string
  default     = "vm02"
}

variable "vm_size" {
  description = "Size of the VMs"
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "Admin username for VMs"
  type        = string
  default     = "azureadmin"
}

variable "admin_password" {
  description = "Admin password for VMs"
  type        = string
  sensitive   = true
}
