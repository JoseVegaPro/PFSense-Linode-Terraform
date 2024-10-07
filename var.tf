# Linode API Token, sensitive value
variable "linodetoken" {
  type      = string
  sensitive = true
  default   = "3f03adb82c57fdda93ed63891961026e6acf0e24959ca67ce0bd2be6c5d9fc73"
}

# Default region is set to Osaka (jp-osa)
variable "region" {
  type    = string
  default = "jp-osa"
}

# Instance type for the Linode (g6-standard-1 is the default)
variable "instancetype" {
  type    = string
  default = "g6-standard-1"
}

# Tags for the Linode instances (a list of strings, not a single string)
variable "tags" {
  type    = list(string)
  default = ["Kibou"]
}

# Number of PFsense instances to create (default is 5)
variable "pfsense_count" {
  type    = number
  default = 5
}
