# vpc-to-vpc-pfsense

Example illustrating connecting a VPC to another VPC using pfSense on EC2
to establish a VPN tunnel.

Generally you'd instead use a Transit Gateway or VPC Peering here. This is just
for testing.

## Steps

### Deploy infra

```
terraform apply
```

### Initialize pfSense

```
ssh admin@<pfsense_1_public_ip>

Option 3
```

- Log in to https://<pfsense_public_ip>
    - admin / pfsense

### Repeat for other pfSense

### Create ipSec tunnel

On PfSense 1:

- VPN -> ipSec
- Create P1
    - Version: IKEv2
    - Remote Gateway: <pfsense_2_public_ip>
    - My Identifier: IP address <pfsense_1_public_ip>
    - Peer Identifier: IP address <pfsense_2_public_ip>
    - Pre-Shared Key: <something>
        - note: ran into odd issues here with auto-generated long key (?)
    - (everything else defaults)
- Create P2
    - Local Subnet: 10.111.0.0/16 (VPC 1 CIDR) **NOT WAN interface which is /24**
    - Remote Subnet: 10.222.0.0/16 (VPC 2 CIDR)
    
### Repeat for other pfSense, in reverse
    
    
### Enable both P1s / P2s

### Ensure connection is established

- Status -> ipsec

```
ping <pfsense_2_private_ip>
```
            
# Debugging

## Logs

```
clog -f /var/log/ipsec.log
```

## pfSense startup failure

I ran into an issue where pfSense would get stuck in initializing on first boot.
System logs showed it auto-reboot for no clear reason. I ended up terminating
and relaunching 3 times until it was stable (same configuration). Not very
satisfying.

# TODO

- modularize VPCs?
