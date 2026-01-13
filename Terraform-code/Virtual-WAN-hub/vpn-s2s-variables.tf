# VPN Gateway Variables
variable "vpn_gateway_name" {
  description = "Name of the VPN Gateway"
  type        = string
  default     = "vpn-gateway"
}

variable "vpn_gateway_scale_unit" {
  description = "Scale unit for the VPN Gateway (1-20)"
  type        = number
  default     = 1
}

# VPN Site Variables
variable "vpn_site_name" {
  description = "Name of the VPN Site (On-Premises)"
  type        = string
  default     = "onprem-site"
}

variable "vpn_site_address_cidrs" {
  description = "Address CIDRs for the on-premises site"
  type        = list(string)
  default     = ["192.168.0.0/16"]
}

variable "vpn_site_link_name" {
  description = "Name of the VPN Site link"
  type        = string
  default     = "onprem-link1"
}

variable "vpn_site_public_ip" {
  description = "Public IP address of the on-premises VPN device"
  type        = string
}

variable "vpn_site_bgp_asn" {
  description = "BGP ASN for the on-premises VPN device (Private range: 64512-65534, except 65515 which is reserved by Azure)"
  type        = number
  default     = 65001
}

variable "vpn_site_bgp_peering_address" {
  description = "BGP peering address for the on-premises VPN device"
  type        = string
  default     = "192.168.1.1"
}

# VPN Connection Variables
variable "vpn_connection_name" {
  description = "Name of the VPN Connection"
  type        = string
  default     = "s2s-connection"
}

variable "vpn_connection_link_name" {
  description = "Name of the VPN Connection link"
  type        = string
  default     = "connection-link1"
}

variable "vpn_shared_key" {
  description = "Shared key (pre-shared key) for VPN connection"
  type        = string
  sensitive   = true
}

variable "vpn_bgp_enabled" {
  description = "Enable BGP for the VPN connection"
  type        = bool
  default     = true
}

variable "vpn_protocol" {
  description = "VPN protocol (IKEv2 or IKEv1)"
  type        = string
  default     = "IKEv2"
  validation {
    condition     = contains(["IKEv2", "IKEv1"], var.vpn_protocol)
    error_message = "VPN protocol must be either IKEv2 or IKEv1."
  }
}
