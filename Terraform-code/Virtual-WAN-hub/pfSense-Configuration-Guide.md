# pfSense Site-to-Site VPN Configuration Guide for Azure Virtual WAN

## Overview
This guide configures pfSense to establish a Site-to-Site VPN connection with Azure Virtual WAN Hub using IKEv2 and BGP routing.

## Prerequisites
- pfSense firewall with public IP address: `157.119.43.99`
- Azure VPN Gateway deployed and operational
- Pre-shared key: `SecureSharedKey123!`

---

## Azure VPN Gateway Information

### Gateway Public IPs (for redundancy)
- **Instance 0:** `52.191.206.73` - BGP IP: `10.0.0.12`
- **Instance 1:** `48.194.31.250` - BGP IP: `10.0.0.13`

### Azure Networks
- Virtual Hub: `10.0.0.0/24`
- Spoke 1 VNet: `10.1.0.0/16`
- Spoke 2 VNet: `10.2.0.0/16`

### Azure BGP Settings
- Azure ASN: `65515`
- BGP Peering Addresses: `10.0.0.12`, `10.0.0.13`

### On-Premises Settings
- On-Prem Network: `192.168.0.0/16`
- On-Prem ASN: `65001`
- BGP Peering Address: `192.168.1.1`

---

## Part 1: IPsec Phase 1 Configuration (Tunnel to Instance 0)

### Navigate to: VPN > IPsec > Tunnels

1. Click **+ Add P1** to create Phase 1

### General Information
- **Description:** `Azure-VWAN-Primary`
- **Disabled:** Unchecked

### IKE Endpoint Configuration
- **Key Exchange version:** `IKEv2`
- **Internet Protocol:** `IPv4`
- **Interface:** `WAN`
- **Remote Gateway:** `52.191.206.73`

### Phase 1 Proposal (Authentication)
- **Authentication Method:** `Mutual PSK`
- **Negotiation mode:** `Main`
- **My identifier:** `My IP address`
- **Peer identifier:** `Peer IP address`
- **Pre-Shared Key:** `SecureSharedKey123!`

### Phase 1 Proposal (Algorithms)
- **Encryption Algorithm:** 
  - ✓ AES 256 bits
  - ✓ AES 128 bits (optional for compatibility)
- **Hash Algorithm:**
  - ✓ SHA256
  - ✓ SHA1 (optional for compatibility)
- **DH Group:**
  - ✓ 2 (1024 bit)
  - ✓ 14 (2048 bit)

### Advanced Options
- **Lifetime:** `28800` seconds
- **Disable Rekey:** Unchecked
- **Disable Reauth:** Unchecked
- **NAT Traversal:** `Auto`
- **Dead Peer Detection:** Check **Enable DPD**
  - **Delay:** `10` seconds
  - **Max failures:** `5`

Click **Save**

---

## Part 2: IPsec Phase 2 Configuration (Tunnel to Instance 0)

1. Click **+ Show Phase 2 Entries** under the Phase 1 you just created
2. Click **+ Add P2**

### General Information
- **Description:** `Azure-VWAN-Primary-P2`
- **Mode:** `Tunnel IPv4`
- **Disabled:** Unchecked

### Networks
- **Local Network:**
  - Type: `Network`
  - Address: `192.168.0.0/16`
- **Remote Network:**
  - Type: `Network`
  - Address: `10.0.0.0/8` (covers all Azure networks: 10.0.0.0/24, 10.1.0.0/16, 10.2.0.0/16)

### Phase 2 Proposal (SA/Key Exchange)
- **Protocol:** `ESP`
- **Encryption Algorithms:**
  - ✓ AES 256 bits
  - ✓ AES 128 bits (optional)
- **Hash Algorithms:**
  - ✓ SHA256
  - ✓ SHA1 (optional)
- **PFS key group:** `2 (1024 bit)`

### Advanced Options
- **Lifetime:** `27000` seconds
- **Automatically ping host:** Leave empty

Click **Save**

---

## Part 3: IPsec Phase 1 Configuration (Tunnel to Instance 1 - Redundancy)

### Repeat the same process for the second tunnel

1. Click **+ Add P1**

### Settings (same as Instance 0, except):
- **Description:** `Azure-VWAN-Secondary`
- **Remote Gateway:** `48.194.31.250`
- **Pre-Shared Key:** `SecureSharedKey123!` (same key)

All other settings remain identical to Instance 0.

Click **Save**

---

## Part 4: IPsec Phase 2 Configuration (Tunnel to Instance 1)

1. Click **+ Show Phase 2 Entries** under the secondary Phase 1
2. Click **+ Add P2**

### Settings (identical to Instance 0 Phase 2):
- **Description:** `Azure-VWAN-Secondary-P2`
- **Local Network:** `192.168.0.0/16`
- **Remote Network:** `10.0.0.0/8`

All other settings remain identical.

Click **Save**

---

## Part 5: Apply IPsec Configuration

1. Click **Apply Changes** at the top of the IPsec page
2. Navigate to **Status > IPsec > Overview**
3. Verify both tunnels show as **ESTABLISHED** (this may take 1-2 minutes)

---

## Part 6: Install FRR Package (for BGP)

### Navigate to: System > Package Manager > Available Packages

1. Search for `frr`
2. Click **Install** next to **FRR** package
3. Wait for installation to complete
4. Confirm installation at **System > Package Manager > Installed Packages**

---

## Part 7: BGP Configuration with FRR

### Navigate to: Services > FRR > Global Settings

1. **Enable FRR:** ✓ Checked
2. **Master Password:** (optional, set if desired)
3. Click **Save**

### Navigate to: Services > FRR > BGP

#### Global Settings
- **Enable:** ✓ Checked
- **Local AS:** `65001`
- **Router ID:** `192.168.1.1` (your BGP peering address)
- **Network Distribute List:** Leave empty (we'll use neighbors)

#### BGP Neighbors

##### Neighbor 1: Azure Instance 0
Click **Add** under BGP Neighbors:
- **Name/Address:** `10.0.0.12`
- **Remote AS:** `65515`
- **Description:** `Azure-Gateway-Instance0`
- **Update Source:** Leave default
- **Next Hop Self:** Unchecked
- **Multi-Hop:** Unchecked

**Advanced Options:**
- **Keep Alive:** `60`
- **Hold Time:** `180`
- **Connection Retry:** `120`

Click **Save**

##### Neighbor 2: Azure Instance 1
Click **Add** under BGP Neighbors:
- **Name/Address:** `10.0.0.13`
- **Remote AS:** `65515`
- **Description:** `Azure-Gateway-Instance1`

(All other settings same as Neighbor 1)

Click **Save**

#### Network Redistribution
Scroll down to **Redistribute** section:
- **Redistribute Connected:** ✓ Checked (to advertise your local networks)
- **Redistribute Static:** ✓ Checked (optional)

Click **Save**

---

## Part 8: Firewall Rules Configuration

### Navigate to: Firewall > Rules > WAN

#### Rule 1: Allow IKE (UDP 500)
Click **Add** (up arrow for top of list):
- **Action:** `Pass`
- **Interface:** `WAN`
- **Address Family:** `IPv4`
- **Protocol:** `UDP`
- **Source:** `Any`
- **Destination:** `WAN address`
- **Destination Port Range:** `500` to `500`
- **Description:** `Allow IKE for Azure VPN`

Click **Save**

#### Rule 2: Allow NAT-T (UDP 4500)
Click **Add**:
- **Action:** `Pass`
- **Interface:** `WAN`
- **Address Family:** `IPv4`
- **Protocol:** `UDP`
- **Source:** `Any`
- **Destination:** `WAN address`
- **Destination Port Range:** `4500` to `4500`
- **Description:** `Allow NAT-T for Azure VPN`

Click **Save**

#### Rule 3: Allow ESP Protocol
Click **Add**:
- **Action:** `Pass`
- **Interface:** `WAN`
- **Address Family:** `IPv4`
- **Protocol:** `ESP`
- **Source:** `Any`
- **Destination:** `WAN address`
- **Description:** `Allow ESP for Azure VPN`

Click **Save**

### Navigate to: Firewall > Rules > IPsec

#### Allow traffic from Azure to On-Premises
Click **Add**:
- **Action:** `Pass`
- **Interface:** `IPsec`
- **Address Family:** `IPv4`
- **Protocol:** `Any`
- **Source:** `Network` - `10.0.0.0/8`
- **Destination:** `Network` - `192.168.0.0/16`
- **Description:** `Allow Azure to On-Prem`

Click **Save**

#### Allow traffic from On-Premises to Azure
Click **Add**:
- **Action:** `Pass`
- **Interface:** `IPsec`
- **Address Family:** `IPv4`
- **Protocol:** `Any`
- **Source:** `Network` - `192.168.0.0/16`
- **Destination:** `Network` - `10.0.0.0/8`
- **Description:** `Allow On-Prem to Azure`

Click **Save**

Click **Apply Changes**

---

## Part 9: Verification and Testing

### Verify IPsec Tunnels
1. Navigate to **Status > IPsec > Overview**
2. Both tunnels should show **ESTABLISHED**
3. Check Statistics to see encrypted traffic

### Verify BGP Sessions
1. Navigate to **Diagnostics > Command Prompt**
2. Enter command: `vtysh -c "show ip bgp summary"`
3. Both neighbors (`10.0.0.12` and `10.0.0.13`) should show state **Established**

### View BGP Routes
1. In Command Prompt, enter: `vtysh -c "show ip bgp"`
2. You should see routes for:
   - `10.0.0.0/24` (Virtual Hub)
   - `10.1.0.0/16` (Spoke 1)
   - `10.2.0.0/16` (Spoke 2)

### Test Connectivity
From a device on your on-premises network (192.168.0.0/16):
```bash
# Ping Azure VM01
ping 10.1.1.4

# Ping Azure VM02
ping 10.2.1.4

# Traceroute to verify routing through VPN
traceroute 10.1.1.4
```

### View IPsec Statistics
Navigate to **Status > IPsec > SADs**
- Check SA (Security Association) entries
- Verify bytes in/out are incrementing

---

## Troubleshooting

### Tunnels won't establish
1. Verify pre-shared key matches on both sides
2. Check that Azure VPN Gateway IPs are correct
3. Verify WAN interface IP is `157.119.43.99` or update Azure VPN Site configuration
4. Check **Status > System Logs > IPsec** for errors

### BGP won't peer
1. Ensure IPsec tunnels are ESTABLISHED first
2. Verify BGP neighbor IPs: `10.0.0.12` and `10.0.0.13`
3. Check ASN numbers: Local `65001`, Remote `65515`
4. Run: `vtysh -c "show bgp neighbor 10.0.0.12"` for detailed status

### No traffic flow
1. Check firewall rules on IPsec interface
2. Verify BGP is advertising your local network
3. Check Azure route tables include on-prem routes
4. Use **Diagnostics > Packet Capture** to trace traffic

### BGP routes not appearing
1. Enable route redistribution for connected networks
2. Verify local network `192.168.0.0/16` exists on pfSense
3. Check: `vtysh -c "show ip route"`

---

## Monitoring Commands

### FRR/BGP Commands (via Diagnostics > Command Prompt)
```bash
# BGP neighbor summary
vtysh -c "show ip bgp summary"

# Detailed neighbor info
vtysh -c "show bgp neighbor 10.0.0.12"

# BGP routes received from Azure
vtysh -c "show ip bgp neighbors 10.0.0.12 routes"

# All BGP routes
vtysh -c "show ip bgp"

# Routing table
vtysh -c "show ip route"

# BGP configuration
vtysh -c "show running-config"
```

---

## Configuration Backup

After successful configuration:
1. Navigate to **Diagnostics > Backup & Restore**
2. Click **Download configuration as XML**
3. Store backup securely

---

## Key Information Summary

| Parameter | Value |
|-----------|-------|
| **Azure Gateway Instance 0** | `52.191.206.73` (BGP: `10.0.0.12`) |
| **Azure Gateway Instance 1** | `48.194.31.250` (BGP: `10.0.0.13`) |
| **Pre-Shared Key** | `SecureSharedKey123!` |
| **Local ASN** | `65001` |
| **Remote ASN** | `65515` |
| **Local BGP Peer** | `192.168.1.1` |
| **On-Prem Network** | `192.168.0.0/16` |
| **Azure Networks** | `10.0.0.0/24`, `10.1.0.0/16`, `10.2.0.0/16` |
| **IKE Version** | `IKEv2` |
| **Encryption** | `AES-256` |
| **Hash** | `SHA-256` |
| **DH Group** | `2 (1024-bit)` |

---

## Next Steps

Once the VPN is established and BGP is working:
1. Test connectivity to Azure VMs at `10.1.1.4` and `10.2.1.4`
2. Configure additional firewall rules as needed for specific services
3. Consider implementing Quality of Service (QoS) for VPN traffic
4. Set up monitoring and alerts for tunnel status
5. Document the configuration and create runbooks for recovery

---

*Configuration Guide Generated: January 13, 2026*
