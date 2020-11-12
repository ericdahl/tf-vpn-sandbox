# openvpn sandbox

## Setup
```
$ terraform apply

$ ssh openvpnas@<vpn_private_ip>

# configure with defaults

$ sudo passwd openvpnas
```

## Admin Page

https://<vpn_private_ip>:943/admin



## Client

### Config

download `client.openvpn` at https://<vpn_private_ip>:943/


```
$ sudo openvpn-client client.ovpn
```

### Validation

```
$ netstat -rn

$ ping <private_ec2_ip>
```