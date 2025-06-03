
variable "vms_resources" {
  description = "Характеристики для всех ВМ"
  type = map(object({
    cores         = number
    memory        = number
    core_fraction = number
    hdd_size      = number
    hdd_type      = string
  }))
  default = {
    web = {
      cores         = 2
      memory        = 2
      core_fraction = 5
      hdd_size      = 10
      hdd_type      = "network-hdd"
    },
    db = {
      cores         = 2
      memory        = 2
      core_fraction = 20
      hdd_size      = 10
      hdd_type      = "network-ssd"
    }
  }
}

variable "metadata" {
  description = "Общие метаданные для всех ВМ"
  type        = map(string)
  default = {
    serial-port-enable = "1"
    ssh-keys           = "ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM5m9AhMRWiO+yybLYEHaJhFaODFZDTbOiYqitAxzWgss alexey@dell"
  }
}

