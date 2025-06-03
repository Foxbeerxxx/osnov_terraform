# Домашнее задание к занятию "`Основы терраформ`" - `Татаринцев Алексей`


   

---

### Задание 1

`* Ключи от YC намерено показаны, ОСОЗНАЮ, что так делать не нужно, но на момент обучения пробую и такой формат ввода`
`* Ключи зменены, после terraform apply и вненесены в лекцию с изменением `


1. `Вношу переменные в variables.tf и прорвожу траблшутинг как итог`
```
###cloud vars

variable "token" {
  description = "IAM token for Yandex Cloud"
  type        = string
  default     = "y0__xCT0ufIBxjB3RMggtW4jxOA51ZsI3f2sKmFlatvU579i7VgfwS"
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
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM5m9AhMRWiO+yybLYEHaJhFaODFZDTbOiYqitAxzWgsS alexey@dell"
  description = "ssh-keygen -t ed25519"
}

```


2. `Следом делаю проверку main.tf и исправляю на`

```
resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}


data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2004-lts"
}
resource "yandex_compute_instance" "platform" {
  name        = "netology-develop-platform-web"
  platform_id = "standard-v1"
  resources {
    cores         = 2
    memory        = 2
    core_fraction = 5
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys = "ubuntu:${var.vms_ssh_root_key}"
  }

}

```


3. `Переодически делая terraform init и terraform apply для понимая и подсвечивания, на что ругается Терраформ`
4. `Как итог terraform init и terraform apply`

![01](https://github.com/Foxbeerxxx/osnov_terraform/blob/main/img/img01.png)`

```
alexey@dell:~/osnov_terraform/02/src$ terraform apply
yandex_vpc_network.develop: Refreshing state... [id=enpk6ebs1acgbv8gcrir]
data.yandex_compute_image.ubuntu: Reading...
data.yandex_compute_image.ubuntu: Read complete after 1s [id=fd8tfha13oaefp88afem]
yandex_vpc_subnet.develop: Refreshing state... [id=e9bua25305mh3d65v9fc]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_instance.platform will be created
  + resource "yandex_compute_instance" "platform" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + gpu_cluster_id            = (known after apply)
      + hardware_generation       = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + maintenance_grace_period  = (known after apply)
      + maintenance_policy        = (known after apply)
      + metadata                  = {
          + "serial-port-enable" = "1"
          + "ssh-keys"           = "ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM5m9AhMRWiO+yybLYEHaJhFaODFZDTbOiYqitAxzWgs alexey@dell"
        }
      + name                      = "netology-develop-platform-web"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd8tfha13oaefp88afem"
              + name        = (known after apply)
              + size        = (known after apply)
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + metadata_options (known after apply)

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = "e9bua25305mh3d65v9fc"
        }

      + placement_policy (known after apply)

      + resources {
          + core_fraction = 5
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = true
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

yandex_compute_instance.platform: Creating...
yandex_compute_instance.platform: Still creating... [10s elapsed]
yandex_compute_instance.platform: Still creating... [20s elapsed]
yandex_compute_instance.platform: Still creating... [30s elapsed]
yandex_compute_instance.platform: Still creating... [40s elapsed]
yandex_compute_instance.platform: Creation complete after 42s [id=fhmhvp4g3pmnv62oodu0]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```


5. `Проверяю,что ВМ создалась и смотрю|, что присвоен внешний ip 62.84.112.72`

![1](https://github.com/Foxbeerxxx/osnov_terraform/blob/main/img/img1.png)

6. `Подключаюсь для проверки, что ssh ключ коректно передался на ВМ`

![2](https://github.com/Foxbeerxxx/osnov_terraform/blob/main/img/img2.png)

7. `Также на самой машине проверяю команду curl ifconfig.me`

![3](https://github.com/Foxbeerxxx/osnov_terraform/blob/main/img/img3.png)

8. `Что касается preemptible = true и core_fraction = 5`

```
Все эти функции очень хорошо могут сэкономить  бюджет на использование в YC

preemptible = true    - Используется только 5% CPU, минимальная нагрузка
preemptible = true  -ВМ может быть прервана в любой момент, зато стоит в 3-4 раза дешевле

```

---

### Задание 2


1. ` Измененный main.tf`
```
resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}


data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_image_family
}
resource "yandex_compute_instance" "platform" {
  name        = var.vm_web_name
  platform_id = var.vm_web_platform_id
  resources {
    cores         = var.vm_web_cores
    memory        = var.vm_web_memory
    core_fraction = var.vm_web_core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vm_web_preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys = "ubuntu:${var.vms_ssh_root_key}"
  }

}

```

2. `И Добавляю все в файл переменных variables.tf`

```
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

###new vars
variable "vm_web_name" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "Имя виртуальной машины"
}

variable "vm_web_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "Платформа для ВМ"
}

variable "vm_web_cores" {
  type        = number
  default     = 2
  description = "Количество ядер"
}

variable "vm_web_memory" {
  type        = number
  default     = 2
  description = "Оперативная память (ГБ)"
}

variable "vm_web_core_fraction" {
  type        = number
  default     = 5
  description = "Доля производительности CPU"
}

variable "vm_web_preemptible" {
  type        = bool
  default     = true
  description = "Прерываемая ли ВМ"
}

variable "vm_web_image_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "Семейство образов для ОС"
}

```


3. `Проверяю terraform plan`

![4](https://github.com/Foxbeerxxx/osnov_terraform/blob/main/img/img4.png)

4. `Получаю нужный результат`

### Задание 3

1. `Создаю vms_platform.tf`
```
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
  name        = var.vm_db_name
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

```

2. `Также вношу изменения в main.tf по части сети`

```
resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}

resource "yandex_vpc_subnet" "develop_b" {
  name           = "${var.vpc_name}-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = ["10.0.2.0/24"]
}

data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_image_family
}
resource "yandex_compute_instance" "platform" {
  name        = var.vm_web_name
  platform_id = var.vm_web_platform_id
  resources {
    cores         = var.vm_web_cores
    memory        = var.vm_web_memory
    core_fraction = var.vm_web_core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vm_web_preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys = "ubuntu:${var.vms_ssh_root_key}"
  }

}

```

3. `Пробиваю terraform inint и terraform apply проеверяю на YC`

![5](https://github.com/Foxbeerxxx/osnov_terraform/blob/main/img/img5.png)


### Задание 4

`Приведите ответ в свободной форме........`

1. `Заполните здесь этапы выполнения, если требуется ....`
2. `Заполните здесь этапы выполнения, если требуется ....`
3. `Заполните здесь этапы выполнения, если требуется ....`
4. `Заполните здесь этапы выполнения, если требуется ....`
5. `Заполните здесь этапы выполнения, если требуется ....`
6. 

```
Поле для вставки кода...
....
....
....
....
```

`При необходимости прикрепитe сюда скриншоты
![Название скриншота](ссылка на скриншот)`
