output "vm_web_info" {
  description = "Информация о Web VM"
  value = {
    name         = yandex_compute_instance.platform.name
    external_ip  = yandex_compute_instance.platform.network_interface[0].nat_ip_address
    fqdn         = yandex_compute_instance.platform.fqdn
  }
}

output "vm_db_info" {
  description = "Информация о DB VM"
  value = {
    name         = yandex_compute_instance.platform_db.name
    external_ip  = yandex_compute_instance.platform_db.network_interface[0].nat_ip_address
    fqdn         = yandex_compute_instance.platform_db.fqdn
  }
}
