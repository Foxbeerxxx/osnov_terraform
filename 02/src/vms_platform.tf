# === Переменные для второй ВМ (DB) ===

variable "vm_db_name" {
  type    = string
  default = "netology-develop-platform-db"
}

variable "vm_db_cores" {
  type    = number
  default = 2
}

variable "vm_db_memory" {
  type    = number
  default = 2
}

variable "vm_db_core_fraction" {
  type    = number
  default = 20
}

variable "vm_db_zone" {
  type    = string
  default = "ru-central1-b"
}

# === Ресурс: Виртуальная машина DB ===

resource "yandex_compute_instance" "platform_db" {
  name        = local.vm_db_name
  platform_id = var.vm_web_platform_id  # используется общая платформа

  zone = var.vm_db_zone

  resources {
    cores         = var.vm_db_cores
    memory        = var.vm_db_memory
    core_fraction = var.vm_db_core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }

  scheduling_policy {
    preemptible = var.vm_web_preemptible  # используется общая переменная
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop_b.id
    nat       = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }
}
