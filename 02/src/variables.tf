###cloud vars

variable "token" {
  description = "IAM token for Yandex Cloud"
  type        = string
  default     = "y0__xCT0ufIBxjB3RMggtW4jxOA51ZsI3f2sKmFlatvU579i7Vgfw"
}


variable "cloud_id" {
  type        = string
  default     = "b1gvjpk4qbrvling8qq1"
  description = "Cloud ID in Yandex.Cloud"
}

variable "folder_id" {
  type        = string
  default     = "b1gse67sen06i8u6ri78"
  description = "Folder ID in Yandex.Cloud"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "Availability zone"
}

variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "Subnet CIDR block"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}


###ssh vars

variable "vms_ssh_root_key" {
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM5m9AhMRWiO+yybLYEHaJhFaODFZDTbOiYqitAxzWgs alexey@dell"
  description = "ssh-keygen -t ed25519"
}
