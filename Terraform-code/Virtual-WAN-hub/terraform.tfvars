# Resource Group and Location
resource_group_name = "rg-vwan-demo"
location            = "East US"

# Virtual WAN Configuration
vwan_name           = "vwan-demo"
vhub_name           = "vhub-demo"
vhub_address_prefix = "10.0.0.0/24"

# Spoke VNet 1 Configuration
spoke1_vnet_name    = "vnet-spoke1"
spoke1_address_space = "10.1.0.0/16"
spoke1_subnet_prefix = "10.1.1.0/24"

# Spoke VNet 2 Configuration
spoke2_vnet_name    = "vnet-spoke2"
spoke2_address_space = "10.2.0.0/16"
spoke2_subnet_prefix = "10.2.1.0/24"

# Virtual Machine Configuration
vm01_name      = "vm01"
vm02_name      = "vm02"
vm_size        = "Standard_B2s"
admin_username = "azureadmin"
# Set admin_ssh_public_key_path to the path of your SSH public key file
# Example: admin_ssh_public_key_path = "~/.ssh/id_rsa.pub"
admin_ssh_public_key_path = "~/.ssh/id_rsa.pub"

# ========================================
# VPN Site-to-Site Configuration
# ========================================

# VPN Gateway Configuration
vpn_gateway_name       = "vpn-gateway-hub"
vpn_gateway_scale_unit = 1

# VPN Site Configuration (On-Premises)
vpn_site_name                 = "onprem-site"
vpn_site_address_cidrs        = ["192.168.0.0/16"]
vpn_site_link_name            = "onprem-link1"
vpn_site_public_ip            = "157.119.43.99"  # Replace with your on-premises VPN device public IP
vpn_site_bgp_asn              = 65001  # Private ASN range: 64512-65534 (65515 is reserved by Azure)
vpn_site_bgp_peering_address  = "192.168.1.1"

# VPN Connection Configuration
vpn_connection_name      = "s2s-connection"
vpn_connection_link_name = "connection-link1"
vpn_shared_key           = "SecureSharedKey123!"  # Replace with your secure shared key
vpn_bgp_enabled          = true
vpn_protocol             = "IKEv2"
