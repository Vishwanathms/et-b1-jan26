# Azure Virtual WAN with 2 Spoke VNets and 2 VMs

This Terraform configuration creates an Azure Virtual WAN setup with two spoke virtual networks, each containing a Windows VM for testing connectivity.

## Architecture

```
Virtual WAN (Hub)
    ├── Virtual Hub (10.0.0.0/24)
    ├── Spoke VNet 1 (10.1.0.0/16)
    │   └── VM01 (Windows Server 2019)
    └── Spoke VNet 2 (10.2.0.0/16)
        └── VM02 (Windows Server 2019)
```

## Resources Created

- **Resource Group**: Contains all resources
- **Virtual WAN**: Central hub for network connectivity
- **Virtual Hub**: Hub within the Virtual WAN
- **2 Spoke VNets**: Separate virtual networks for each VM
- **2 Subnets**: One in each spoke VNet
- **2 VMs**: Windows Server 2019 machines
- **2 Public IPs**: For RDP access to VMs
- **2 NICs**: Network interfaces for VMs
- **2 NSGs**: Network security groups allowing RDP and ICMP (ping)
- **Hub Connections**: Connecting spoke VNets to the Virtual Hub

## Prerequisites

- Azure CLI installed and authenticated
- Terraform installed (v1.0+)
- Azure subscription with appropriate permissions

## Configuration

1. **Review and update** [terraform.tfvars](terraform.tfvars) with your desired values
2. **Important**: Change the `admin_password` to a secure password meeting Azure requirements:
   - At least 12 characters
   - Contains uppercase, lowercase, numbers, and special characters

## Deployment Steps

### 1. Initialize Terraform
```bash
cd Virtual-WAN-hub
terraform init
```

### 2. Review the Plan
```bash
terraform plan
```

### 3. Apply the Configuration
```bash
terraform apply
```

Type `yes` when prompted. Deployment takes approximately 20-30 minutes (Virtual WAN Hub creation is time-consuming).

### 4. Retrieve Outputs
```bash
terraform output
```

This shows:
- VM private and public IP addresses
- Admin username
- Test connectivity command

## Testing Connectivity (VM01 to VM02)

### Method 1: Using RDP

1. **Get VM01 Public IP**:
   ```bash
   terraform output vm01_public_ip
   ```

2. **RDP to VM01**:
   - Open Remote Desktop Connection
   - Connect to VM01's public IP
   - Username: `azureadmin` (or your configured admin_username)
   - Password: Your admin_password from terraform.tfvars

3. **Ping VM02 from VM01**:
   ```powershell
   # Get VM02 private IP from Terraform outputs
   ping <VM02_PRIVATE_IP>
   ```
   
   Example:
   ```powershell
   ping 10.2.1.4
   ```

4. **Expected Result**: 
   - You should see successful ping replies
   - This confirms connectivity through the Virtual WAN Hub

### Method 2: Using Azure Bastion (Optional)

If you have Azure Bastion deployed, you can use it instead of public IPs for more secure access.

## Verification Steps

1. **Check Virtual Hub Routing**:
   - Navigate to Azure Portal → Virtual WAN → Virtual Hub
   - Check "Effective Routes" to verify spoke networks are advertised

2. **Check Hub Connections**:
   - Verify both spoke VNet connections show "Succeeded" status
   - Check routing status is "Provisioned"

3. **Network Security Groups**:
   - Verify ICMP (ping) is allowed in both NSGs
   - Verify RDP (port 3389) is allowed for management

## Network Topology

- **Virtual Hub**: 10.0.0.0/24
- **Spoke 1 VNet**: 10.1.0.0/16
  - Subnet: 10.1.1.0/24
  - VM01: Dynamic IP from subnet
- **Spoke 2 VNet**: 10.2.0.0/16
  - Subnet: 10.2.1.0/24
  - VM02: Dynamic IP from subnet

## Costs

This setup incurs costs for:
- Virtual WAN Hub (~$0.25/hour)
- Virtual Hub connections (~$0.05/hour each)
- Virtual Machines (Standard_B2s)
- Public IP addresses
- Data transfer

**Remember to destroy resources when done testing!**

## Cleanup

To destroy all resources:

```bash
terraform destroy
```

Type `yes` when prompted. This will remove all created resources.

## Troubleshooting

### Ping Not Working

1. **Check NSG Rules**: Ensure ICMP is allowed
2. **Check Windows Firewall**: On the VMs, ensure Windows Firewall allows ICMP
   ```powershell
   # Run on both VMs to allow ping
   netsh advfirewall firewall add rule name="ICMP Allow incoming V4 echo request" protocol=icmpv4:8,any dir=in action=allow
   ```

3. **Check Hub Connection Status**: Verify both connections are in "Succeeded" state
4. **Check Effective Routes**: In Azure Portal, check VM's NIC effective routes

### Hub Creation Takes Long Time

Virtual WAN Hub provisioning typically takes 15-30 minutes. This is normal Azure behavior.

### RDP Connection Issues

1. Verify NSG allows port 3389
2. Check VM is running in Azure Portal
3. Verify public IP is assigned

## Additional Resources

- [Azure Virtual WAN Documentation](https://docs.microsoft.com/azure/virtual-wan/)
- [Terraform AzureRM Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)

## File Structure

```
Virtual-WAN-hub/
├── main.tf           # Main Terraform configuration
├── variables.tf      # Variable definitions
├── terraform.tfvars  # Variable values
├── outputs.tf        # Output definitions
└── README.md         # This file
```
