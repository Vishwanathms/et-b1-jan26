# Azure Hub-Spoke Network Topology with Terraform

This Terraform configuration deploys a hub-spoke network topology in Azure based on the provided network diagram.

## Architecture Overview

### Network Components

- **Hub VNet**: 10.0.0.0/16
- **Spoke1 VNet**: 10.1.0.0/16
  - Subnet: 10.1.0.0/24
  - VM01: Ubuntu B2s_v2 with public IP
- **Spoke2 VNet**: 10.2.0.0/16
  - Subnet: 10.2.0.0/24
  - VM02: Ubuntu B2s_v2 without public IP

### VNet Peering

- **Peer1**: Hub ↔ Spoke1
- **Peer2**: Hub ↔ Spoke2

### Route Tables

**Spoke1 Routes:**
- 10.0.0.0/16 → Peer1 (Auto)
- 0.0.0.0/0 → Internet (Auto)
- 10.2.0.0/16 → Peer1 (Manual)

**Spoke2 Routes:**
- 10.0.0.0/16 → Peer2 (Auto)
- 0.0.0.0/0 → Internet (Auto)
- 10.1.0.0/16 → Peer2 (Manual)

## Prerequisites

1. Azure CLI installed and configured
2. Terraform installed (version 1.0+)
3. Azure subscription with appropriate permissions
4. SSH key pair generated at `~/.ssh/id_rsa.pub` (or update the path in variables)

## Usage

### Initialize Terraform

```bash
terraform init
```

### Review the Execution Plan

```bash
terraform plan
```

### Deploy the Infrastructure

```bash
terraform apply
```

### Destroy the Infrastructure

```bash
terraform destroy
```

## Accessing the VMs

### VM01 (with Public IP)

After deployment, use the output to get the SSH command:

```bash
terraform output vm01_ssh_command
```

Or manually:

```bash
ssh azureuser@<VM01_PUBLIC_IP>
```

### VM02 (without Public IP)

VM02 can only be accessed via VM01 (jump host):

```bash
# First, SSH to VM01
ssh azureuser@<VM01_PUBLIC_IP>

# From VM01, SSH to VM02 using its private IP
ssh azureuser@<VM02_PRIVATE_IP>
```

## Configuration

All configuration values are provided via the `terraform.tfvars` file. Review and modify this file before deployment:

```hcl
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
vm_size   = "Standard_B2s_v2"

# VM Authentication
admin_username       = "azureuser"
ssh_public_key_path  = "~/.ssh/id_rsa.pub"
```

**Important**: Make sure to update `ssh_public_key_path` to point to your actual SSH public key location before deployment.

## Resources Created

- 1 Resource Group
- 3 Virtual Networks (Hub, Spoke1, Spoke2)
- 2 Subnets
- 4 VNet Peerings
- 2 Route Tables with associations
- 2 Network Security Groups
- 1 Public IP Address
- 2 Network Interfaces
- 2 Linux Virtual Machines (Ubuntu)

## Security Considerations

- VM01 has SSH (port 22) open to the internet - consider restricting to your IP
- VM02 only accepts SSH from Spoke1 network range
- No public IP assigned to VM02 for enhanced security
- All VMs use SSH key authentication (password authentication disabled)

## Notes

- The SSH public key path defaults to `~/.ssh/id_rsa.pub` - ensure this file exists or update the path
- The VMs use Ubuntu 22.04 LTS
- VM size is set to Standard_B2s_v2 (1 CPU, 2 GB RAM) as per the diagram
- Route propagation is handled automatically by Azure for peered networks
