# VPN Gateway Outputs
output "vpn_gateway_id" {
  description = "ID of the VPN Gateway"
  value       = azurerm_vpn_gateway.vpn_gateway.id
}

output "vpn_gateway_name" {
  description = "Name of the VPN Gateway"
  value       = azurerm_vpn_gateway.vpn_gateway.name
}

# VPN Site Outputs
output "vpn_site_id" {
  description = "ID of the VPN Site"
  value       = azurerm_vpn_site.onprem_site.id
}

output "vpn_site_name" {
  description = "Name of the VPN Site"
  value       = azurerm_vpn_site.onprem_site.name
}

# VPN Connection Outputs
output "vpn_connection_id" {
  description = "ID of the VPN Connection"
  value       = azurerm_vpn_gateway_connection.s2s_connection.id
}

output "vpn_connection_name" {
  description = "Name of the VPN Connection"
  value       = azurerm_vpn_gateway_connection.s2s_connection.name
}
