output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.rg.name
}

output "virtual_wan_id" {
  description = "ID of the Virtual WAN"
  value       = azurerm_virtual_wan.vwan.id
}

output "virtual_hub_id" {
  description = "ID of the Virtual Hub"
  value       = azurerm_virtual_hub.hub.id
}

output "spoke1_vnet_id" {
  description = "ID of Spoke VNet 1"
  value       = azurerm_virtual_network.spoke1.id
}

output "spoke2_vnet_id" {
  description = "ID of Spoke VNet 2"
  value       = azurerm_virtual_network.spoke2.id
}

output "vm01_private_ip" {
  description = "Private IP address of VM01"
  value       = azurerm_network_interface.vm01_nic.private_ip_address
}

output "vm01_public_ip" {
  description = "Public IP address of VM01"
  value       = azurerm_public_ip.vm01_pip.ip_address
}

output "vm02_private_ip" {
  description = "Private IP address of VM02"
  value       = azurerm_network_interface.vm02_nic.private_ip_address
}

output "vm02_public_ip" {
  description = "Public IP address of VM02"
  value       = azurerm_public_ip.vm02_pip.ip_address
}

output "admin_username" {
  description = "Admin username for VMs"
  value       = var.admin_username
}

output "test_connectivity_command" {
  description = "Command to test connectivity from VM01 to VM02"
  value       = "RDP to VM01 (${azurerm_public_ip.vm01_pip.ip_address}) and run: ping ${azurerm_network_interface.vm02_nic.private_ip_address}"
}
