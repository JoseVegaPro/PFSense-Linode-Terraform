# PFSense-Linode-Terraform
DIY NAT IPSec GW that runs on Akamai Connected Cloud

## PFSense Image
Download the PFsense image from [PFSense](https://www.pfsense.org/download/)  
Version: `Latest`  
Architecture: `AMD64`    
Installer: `USB Memstick Installer`  
Console: `Serial`  

> [!TIP]
> Upload the image to Linode Object Storage as you will be needing to curl it to the Disk via Lish Console

## Rescue Linode
Reboot into Rescue mode
/dev/sda: `Installer`  
/dev/sdb: `None`  
/dev/sdc: `None`  
Launch Lish Console  
curl your image and write to | dd  of=/dev/sda
```
curl https://Object_storage_URL_goes_here.com/pfSense-CE-memstick-serial-2.7.0-RELEASE-amd64.img | dd  of=/dev/sda
```
Boot into `Installer` Configuration  
Console type [vt100]: `xterm`  
Follow Setup Wizard  
Boot into `PFSense`  
Follow Setup Wizard
>[!IMPORTANT]
>Create a firewall Rule from x.x.x.x (the client IP address) to y.y.y.y ( the WAN IP address) on TCP port 443: to be able to manage the firewall
 ```
 easyrule pass wan tcp x.x.x.x y.y.y.y 443  
 ```
