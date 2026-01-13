# Resource Group Configuration
resource_group_name = "rg-hub-spoke-network"
location            = "East US"

# Hub Virtual Network
hub_vnet_name          = "vnet-hub"
hub_vnet_address_space = ["10.0.0.0/16"]

# Spoke1 Virtual Network
spoke1_vnet_name               = "vnet-spoke1"
spoke1_vnet_address_space      = ["10.1.0.0/16"]
spoke1_subnet_name             = "subnet-spoke1"
spoke1_subnet_address_prefix   = ["10.1.0.0/24"]

# Spoke2 Virtual Network
spoke2_vnet_name               = "vnet-spoke2"
spoke2_vnet_address_space      = ["10.2.0.0/16"]
spoke2_subnet_name             = "subnet-spoke2"
spoke2_subnet_address_prefix   = ["10.2.0.0/24"]

# Virtual Machines
vm01_name = "vm01"
vm02_name = "vm02"
vm_size   = "Standard_B1ms"

# VM Authentication
admin_username       = "azureuser"
ssh_public_key_path  = "~/.ssh/id_rsa.pub"

# VPN Gateway Configuration
gateway_subnet_address_prefix = ["10.0.2.0/24"]
vpn_gateway_name              = "vpn-gateway-hub"
vpn_gateway_pip_name          = "pip-vpn-gateway-hub"
vpn_gateway_sku               = "VpnGw1"
vpn_client_address_space      = ["172.16.0.0/24"]
vpn_root_certificate_name     = "P2SRootCert"
vpn_root_certificate_data     = "MIIC7zCCAdegAwIBAgIQGeycZdjFPIZHpDtz1qLz8jANBgkqhkiG9w0BAQsFADAaMRgwFgYDVQQDDA9QMlNSb290Q2VydC1MYWIwHhcNMjYwMTEyMDYxNzI0WhcNMjcwMTEyMDYzNzI0WjAaMRgwFgYDVQQDDA9QMlNSb290Q2VydC1MYWIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC1YInhjsqFXAHjo4g0W5b7N1vpN7P5HkAtL8iRLt5xJHPFLjsOM+7YWSpOAGUnylEgxKORrHWQ4VJQYcMN7Bh0oatEuCoj76eWuiHhKXMrFDxWAcNPvCZiX+c1aRugHIb1KgJdWdgFf5fz4oUhviIkPUsVAKcG9u3em7YCicJeeCBD95znh9X5a/Rr+/qqNm+opwk5Z11h3XDAR5qzFQfPrn1ldQDHbbUFEB4BtTVZBiUi0HrfXblk1LEQgQqP2nZFvKaObMTZIvU5vaHiae6vf/D+QUZbNm5x4Qs2ACdb6N9LziE6HpMH42Mkf598BeX79BB/xQgqL9rWKIy+byudAgMBAAGjMTAvMA4GA1UdDwEB/wQEAwICBDAdBgNVHQ4EFgQUfvcZ/JX0t4pf4dqCo/nadyvrCGIwDQYJKoZIhvcNAQELBQADggEBAEoYUrW3DYDBzWu+zEeRRpDynRL8/D1N7yhYwOCy9fek5UBprCpskBU39IHBbbZdSMujlpOcPgZtbVJT0mP89+NRz0oMvKIfpLaPfZZS9y6fUZLcqE/53lBcd3qZue5r31TK0KHDssYCc6+OyLmn4vUnd9oSSQpY7vGhaRJRsEqSDja4K8KTK+KicOa2ayuIjFvceK3hzOjFF285s/mY5AqYAScv5WEDgr/A36d/OC2xV1f+w4wMu1S1rai1fTt+z9Ws6NGCwn1t7JmPSxlQlJhAJQAdOCzpryUCTsJyZeQtIynj6UG0AgpwquDzQ+lwy+iq2n8h7hclTGjVWOx2OJ0="
vpn_client_protocols          = ["OpenVPN", "IkeV2"]
