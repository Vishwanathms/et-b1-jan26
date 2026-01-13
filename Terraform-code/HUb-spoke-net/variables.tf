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

# VPN Gateway Variables
variable "gateway_subnet_address_prefix" {
  description = "Address prefix for Gateway Subnet"
  type        = list(string)
}

variable "vpn_gateway_name" {
  description = "Name of the VPN Gateway"
  type        = string
}

variable "vpn_gateway_pip_name" {
  description = "Name of the VPN Gateway Public IP"
  type        = string
}

variable "vpn_gateway_sku" {
  description = "SKU for VPN Gateway (Basic, VpnGw1, VpnGw2, VpnGw3, VpnGw1AZ, VpnGw2AZ, VpnGw3AZ)"
  type        = string
  default     = "VpnGw1"
}

variable "vpn_client_address_space" {
  description = "Address space for VPN clients (Point-to-Site)"
  type        = list(string)
}

variable "vpn_root_certificate_name" {
  description = "Name of the root certificate for VPN"
  type        = string
}

variable "vpn_root_certificate_data" {
  description = "Public certificate data (base64 encoded, without BEGIN/END CERTIFICATE headers)"
  type        = string
  sensitive   = true
}

variable "vpn_client_protocols" {
  description = "VPN client protocols (OpenVPN, IkeV2)"
  type        = list(string)
  default     = ["OpenVPN", "IkeV2"]
}
