# ------------------------------
# Outputs
# ------------------------------

output "azure_vpn_gateway_public_ip" {
  description = "⭐ 이 IP를 AWS Customer Gateway에 입력하세요!"
  value       = azurerm_public_ip.vpn_gateway_ip.ip_address
}

output "resource_group_name" {
  description = "Resource Group name"
  value       = azurerm_resource_group.dr_rg.name
}

output "public_ip" {
  description = "Public IP address (Dynamic - allocated after VM starts)"
  value       = azurerm_public_ip.dr_public_ip.ip_address
}

output "vm_name" {
  description = "VM name"
  value       = azurerm_linux_virtual_machine.dr_vm.name
}

output "vm_id" {
  description = "VM resource ID"
  value       = azurerm_linux_virtual_machine.dr_vm.id
}

output "ssh_command" {
  description = "SSH connection command"
  value       = "ssh ${var.admin_username}@${azurerm_public_ip.dr_public_ip.ip_address}"
}

output "web_url" {
  description = "Web server URL"
  value       = "http://${azurerm_public_ip.dr_public_ip.ip_address}"
}

output "vnet_id" {
  value = azurerm_virtual_network.dr_vnet.id
}

output "next_steps" {
  value = <<-EOT
  
  ═══════════════════════════════════════════════
  Azure VPN Gateway 배포 완료!
  ═══════════════════════════════════════════════
  
  📍 Azure VPN Gateway Public IP: ${azurerm_public_ip.vpn_gateway_ip.ip_address}
  
  다음 단계:
  1. AWS Console → VPC → Customer Gateways 생성
     - IP Address: ${azurerm_public_ip.vpn_gateway_ip.ip_address}
     - BGP ASN: 65515
  
  2. AWS Console → VPC → Site-to-Site VPN Connections 생성
  
  3. AWS Tunnel Outside IP 확인 후
     terraform apply로 Local Network Gateway 업데이트
  
  ═══════════════════════════════════════════════
  EOT
}