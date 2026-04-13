provider "yandex" {
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
}

resource "yandex_compute_instance" "vm" {
  name = var.vm_name

  resources {
    cores  = var.vcpu_count
    memory = var.ram_size_mb / 1024
  }

  boot_disk {
    initialize_params {
      image_id = "fd827b91d99psvq5fjit"  # Ubuntu 22.04 LTS
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_public_key}"
  }
}