# site-to-site VPN

This is a standalone test VPC used to establish a Site to Site VPN with an external network

It's for testing/learning purposes only.

Currently, using pfsense for the other Site

## Steps

### Deploy core infra

```
# terraform apply
```

### Set up Site B configuration

- In VPC Console under `Site-to-site VPN Connections`, select the new connection
and then select `Download Configuration`. For this, I'm using pfSense.
- Open text file with instructions
- In pfSense console, follow instructions to add:
    - Two Phase 1 IPSec Tunnels, one for each IP provided in the VPN Connection from AWS
        - For each one, a Phase 2 Entry
            - **note: select correct local subnet; in my case it is not the LAN subnet**
- Apply changes

### Wait for VPN Connection to establish

- Select `Tunnel Details` tab in VPC Connection
- This may take 5-10 minutes for each Tunnel to have a Status of `UP`

### Verify connection

```
$ ping <private_ip>
```

### Adjust FW Rules as needed

For VPC to Site B traffic, most likely need to add new FW rules on IPSec interface. (default is deny)

