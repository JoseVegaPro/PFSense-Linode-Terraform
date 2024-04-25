variable "linodetoken" {
  type      = string
  sensitive = true
  default   = "YOUR_LINODE_API_TOKEN_HERE"
}
variable "region" {
  type    = string
  # If you do not specify a region, Osaka is set to be the default. Modify to the region of your choice
  default = "jp-osa"
}
variable "instancetype" {
  type    = string
  default = "g6-standard-1"
}
variable "tags" {
  type    = string
  default = "Kibou"
}