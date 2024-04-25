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
## Clone the Repo
Clone the repo by copying the commands below  
```
git clone https://github.com/JoseVegaPro/PFSense-Linode-Terraform/
```
CD into 
```
cd PFSense-Linode-Terraform
```

## Rescue Linode
Reboot into Rescue mode
/dev/sda: `Installer`  
/dev/sdb: `None`  
/dev/sdc: `None`  
Launch Lish Console  
curl your image and write to | dd  of=/dev/sda 
Example command below
```
curl https://Object_storage_URL_goes_here.com/pfSense-CE-memstick-serial-2.7.0-RELEASE-amd64.img | dd  of=/dev/sda
```
Boot into `Installer` 
On your Lish Console you will be selecting type [vt100]: `xterm` Follow Setup Wizard  
After you have completed the setup Wizard on the Installer configuration Boot into `PFSense`  
On your Lish Console you will now configure the PFSense Initial configuration.  

## Accessing PFSense GUI
Upon Completion you will be presented with 16 options on your Lish Console  

Select `Shell` by typing the number `8`  
>[!IMPORTANT]
>Create a firewall Rule from x.x.x.x (the client IP address) to y.y.y.y ( the WAN IP address) on TCP port 443: to be able to manage the firewall
 ```
 easyrule pass wan tcp x.x.x.x y.y.y.y 443  
 ```

After you created the firewall rule. Type the following command to be able to access the GUI for the first time.
```
pfctl -d
```

Copy your Public IP Address into your preferred browser.  

The default credentials:  
`admin`  
`pfsense`  