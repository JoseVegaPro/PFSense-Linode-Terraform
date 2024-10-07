# Create multiple PFsense Linode instances
resource "linode_instance" "PFSense" {
  count  = var.pfsense_count
  label  = "PFSense-${count.index + 1}"
  region = var.region
  type   = var.instancetype
  tags   = var.tags
}

# Create installer disk for each PFsense instance
resource "linode_instance_disk" "installer_disk" {
  count      = var.pfsense_count
  label      = "installer"
  linode_id  = linode_instance.PFSense[count.index].id
  filesystem = "raw"
  size       = 2000
}

# Create main disk for each PFsense instance
resource "linode_instance_disk" "PFSense_disk" {
  count      = var.pfsense_count
  label      = "PFSense"
  linode_id  = linode_instance.PFSense[count.index].id
  filesystem = "raw"
  size       = 48000
}

# Create installer config for each PFsense instance
resource "linode_instance_config" "installer" {
  count      = var.pfsense_count
  label      = "installer"
  linode_id  = linode_instance.PFSense[count.index].id
  kernel     = "linode/direct-disk"
  root_device = "/dev/sdb"

  device {
    device_name = "sda"
    disk_id     = linode_instance_disk.PFSense_disk[count.index].id
  }
  
  device {
    device_name = "sdb"
    disk_id     = linode_instance_disk.installer_disk[count.index].id
  }

  helpers {
    updatedb_disabled = false
    distro            = false
    modules_dep       = false
    devtmpfs_automount = false
  }
}

# Create PFsense config for each PFsense instance
resource "linode_instance_config" "PFSense" {
  count      = var.pfsense_count
  label      = "PFSense"
  linode_id  = linode_instance.PFSense[count.index].id
  kernel     = "linode/direct-disk"
  root_device = "/dev/sda"

  device {
    device_name = "sda"
    disk_id     = linode_instance_disk.PFSense_disk[count.index].id
  }

  interface {
    purpose = "public"
  }

  interface {
    purpose      = "vlan"
    label        = "1989"
    ipam_address = "10.19.89.${count.index + 7}/24"
  }

  helpers {
    updatedb_disabled = false
    distro            = false
    modules_dep       = false
    devtmpfs_automount = false
  }
}
