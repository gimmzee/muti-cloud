# ============================================
# Gateway Subnet (VPN Gateway 전용)
# ============================================
resource "azurerm_subnet" "gateway_subnet" {
  name                 = "GatewaySubnet"  # 이름 고정 필수!
  resource_group_name  = azurerm_resource_group.dr_rg.name
  virtual_network_name = azurerm_virtual_network.dr_vnet.name
  address_prefixes     = ["10.10.255.0/27"]  # /27 이상 권장
}

# ============================================
# Public IP for VPN Gateway
# ============================================
resource "azurerm_public_ip" "vpn_gateway_ip" {
  name                = "azure-vpn-gateway-ip"
  location            = azurerm_resource_group.dr_rg.location
  resource_group_name = azurerm_resource_group.dr_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  
  tags = {
    Purpose = "AWS-VPN-Connection"
  }
}

# ============================================
# Virtual Network Gateway (약 30-45분 소요)
# ============================================
resource "azurerm_virtual_network_gateway" "vpn_gateway" {
  name                = "azure-vpn-gateway"
  location            = azurerm_resource_group.dr_rg.location
  resource_group_name = azurerm_resource_group.dr_rg.name
  
  type     = "Vpn"
  vpn_type = "RouteBased"
  
  active_active = false
  enable_bgp    = true
  sku           = "VpnGw1"  # 기본 스펙
  
  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.vpn_gateway_ip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gateway_subnet.id
  }
  
  bgp_settings {
    asn = 65515  # Azure 기본 ASN
  }
}

# ============================================
# Local Network Gateway (나중에 AWS 정보 입력)
# ============================================
resource "azurerm_local_network_gateway" "aws_lng" {
  name                = "aws-local-gateway"
  location            = azurerm_resource_group.dr_rg.location
  resource_group_name = azurerm_resource_group.dr_rg.name
  
  # ⚠️ 임시값: AWS VPN Tunnel 생성 후 실제 IP로 변경 필요
  gateway_address = "43.200.234.153"  # AWS Tunnel IP로 나중에 변경
  
  address_space = ["10.1.0.0/16"]  # AWS VPC CIDR
  
  bgp_settings {
    asn                 = 64512  # AWS VGW 기본 ASN
    bgp_peering_address = "169.254.100.1"  # AWS Tunnel Inside IP
  }
}

# ============================================
# VPN Connection (나중에 생성)
# ============================================
resource "azurerm_virtual_network_gateway_connection" "azure_to_aws" {
  name                = "azure-to-aws-vpn"
  location            = azurerm_resource_group.dr_rg.location
  resource_group_name = azurerm_resource_group.dr_rg.name
  
  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.vpn_gateway.id
  local_network_gateway_id   = azurerm_local_network_gateway.aws_lng.id
  
  shared_key = "AzureAWSVPN2024"  # 16자 이상
  
  enable_bgp = true
  
  ipsec_policy {
    dh_group         = "DHGroup2"
    ike_encryption   = "AES128"
    ike_integrity    = "SHA1"
    ipsec_encryption = "AES128"
    ipsec_integrity  = "SHA1"
    pfs_group        = "PFS2"
    sa_lifetime      = 27000
  }
}