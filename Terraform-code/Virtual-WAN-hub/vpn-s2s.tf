# VPN Gateway for Virtual Hub
resource "azurerm_vpn_gateway" "vpn_gateway" {
  name                = var.vpn_gateway_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  virtual_hub_id      = azurerm_virtual_hub.hub.id
  scale_unit          = var.vpn_gateway_scale_unit
}

# VPN Site (On-Premises)
resource "azurerm_vpn_site" "onprem_site" {
  name                = var.vpn_site_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  virtual_wan_id      = azurerm_virtual_wan.vwan.id
  address_cidrs       = var.vpn_site_address_cidrs

  link {
    name       = var.vpn_site_link_name
    ip_address = var.vpn_site_public_ip
    bgp {
      asn             = var.vpn_site_bgp_asn
      peering_address = var.vpn_site_bgp_peering_address
    }
  }
}

# VPN Connection
resource "azurerm_vpn_gateway_connection" "s2s_connection" {
  name               = var.vpn_connection_name
  vpn_gateway_id     = azurerm_vpn_gateway.vpn_gateway.id
  remote_vpn_site_id = azurerm_vpn_site.onprem_site.id

  vpn_link {
    name             = var.vpn_connection_link_name
    vpn_site_link_id = azurerm_vpn_site.onprem_site.link[0].id
    shared_key       = var.vpn_shared_key
    bgp_enabled      = var.vpn_bgp_enabled
    protocol         = var.vpn_protocol
  }
}
