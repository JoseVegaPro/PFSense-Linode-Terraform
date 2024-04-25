resource "linode_instance" "PFSense" {
  label = "PFSense-00"
  region = var.region
  type = var.instancetype
  tags = [ var.tags ]
}
resource "linode_instance_disk" "installer_disk" {
  label = "installer"
  linode_id = linode_instance.PFSense.id
  filesystem = "raw"
  size = 2000
}
resource "linode_instance_disk" "PFSense_disk" {
  label = "PFSense"
  linode_id = linode_instance.PFSense.id
  filesystem = "raw"
  size = 48000
}
resource "linode_instance_config" "installer" {
  label = "installer"
  linode_id = linode_instance.PFSense.id
  kernel = "linode/direct-disk"
  root_device = "/dev/sdb"
  device {
    device_name = "sda"
    disk_id = linode_instance_disk.PFSense_disk.id
  }
  device {
    device_name = "sdb"
    disk_id = linode_instance_disk.installer_disk.id
  }
  helpers {
    updatedb_disabled = false
    distro = false
    modules_dep = false
    devtmpfs_automount = false
  }
}
resource "linode_instance_config" "PFSense" {
  label = "PFSense"
  linode_id = linode_instance.PFSense.id
  kernel = "linode/direct-disk"
  root_device = "/dev/sda"
  device {
    device_name = "sda"
    disk_id = linode_instance_disk.PFSense_disk.id
  }
  interface {
    purpose = "public"
  }
  interface {
    purpose = "vlan"
    label = "1989"
    #You can modify the CIDR Subnet to meet your requirements, by default this is set to 10.19.89.0/24 assigning 10.19.89.7 to the LAN Interface of the PFSense FW
    ipam_address = "10.19.89.7/24"
  }
  helpers {
    updatedb_disabled = false
    distro = false
    modules_dep = false
    devtmpfs_automount = false
  }
}