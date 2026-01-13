# VPN Gateway Subnet in Hub VNet
resource "azurerm_subnet" "gateway_subnet" {
  name                 = "GatewaySubnet"  # This name is required by Azure
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = var.gateway_subnet_address_prefix
}

# Public IP for VPN Gateway
resource "azurerm_public_ip" "vpn_gateway_pip" {
  name                = var.vpn_gateway_pip_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Virtual Network Gateway (VPN Gateway)
resource "azurerm_virtual_network_gateway" "vpn_gateway" {
  name                = var.vpn_gateway_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = var.vpn_gateway_sku

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.vpn_gateway_pip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gateway_subnet.id
  }

  vpn_client_configuration {
    address_space = var.vpn_client_address_space

    root_certificate {
      name             = var.vpn_root_certificate_name
      public_cert_data = var.vpn_root_certificate_data
    }

    vpn_client_protocols = var.vpn_client_protocols
  }

  depends_on = [azurerm_subnet.gateway_subnet, azurerm_public_ip.vpn_gateway_pip]
}
