output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.rg.name
}

output "hub_vnet_id" {
  description = "ID of the Hub virtual network"
  value       = azurerm_virtual_network.hub.id
}

output "spoke1_vnet_id" {
  description = "ID of the Spoke1 virtual network"
  value       = azurerm_virtual_network.spoke1.id
}

output "spoke2_vnet_id" {
  description = "ID of the Spoke2 virtual network"
  value       = azurerm_virtual_network.spoke2.id
}

output "vm01_public_ip" {
  description = "Public IP address of VM01"
  value       = azurerm_public_ip.vm01_pip.ip_address
}

output "vm01_private_ip" {
  description = "Private IP address of VM01"
  value       = azurerm_network_interface.vm01_nic.private_ip_address
}

output "vm02_private_ip" {
  description = "Private IP address of VM02"
  value       = azurerm_network_interface.vm02_nic.private_ip_address
}

output "vm01_ssh_command" {
  description = "SSH command to connect to VM01"
  value       = "ssh azureuser@${azurerm_public_ip.vm01_pip.ip_address}"
}

output "firewall_private_ip" {
  description = "Private IP address of Azure Firewall"
  value       = azurerm_firewall.hub_firewall.ip_configuration[0].private_ip_address
}

output "firewall_public_ip" {
  description = "Public IP address of Azure Firewall"
  value       = azurerm_public_ip.firewall_pip.ip_address
}
