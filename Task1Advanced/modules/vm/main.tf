# Local variables for naming conventions
locals {
  full_vm_name = "${var.vm_name}-${var.environment}"

  common_tags = merge(var.tags, {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Module      = "vm_module"
    CreatedAt   = timestamp()
  })
}

# Compute instance resource
resource "yandex_compute_instance" "vm" {
  name        = local.full_vm_name
  platform_id = var.platform_id
  zone        = var.availability_zone

  resources {
    cores         = var.vcpu_count
    memory        = var.ram_size_mb
    core_fraction = var.environment == "prod" ? 100 : 50
  }

  boot_disk {
    initialize_params {
      image_id = var.os_image_id
      size     = var.boot_disk_size_gb
      type     = var.boot_disk_type
    }
  }

  # Additional disk
  dynamic "secondary_disk" {
    for_each = var.disk_size_gb > 0 ? [1] : []
    content {
      initialize_params {
        size = var.disk_size_gb
        type = var.disk_type
      }
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = var.environment != "prod" ? true : false
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_public_key}"
    user-data = templatefile("${path.module}/cloud-init.tpl", {
      environment = var.environment
      vm_name     = var.vm_name
    })
  }

  labels = local.common_tags

  allow_stopping_for_update = true
}

# Additional resources for production environment
resource "yandex_compute_disk" "data_disk" {
  count = var.environment == "prod" && var.disk_size_gb > 0 ? 1 : 0

  name     = "${local.full_vm_name}-data-disk"
  type     = var.disk_type
  size     = var.disk_size_gb
  zone     = var.availability_zone

  labels = local.common_tags
}

resource "yandex_compute_instance_disk_attachment" "data_attachment" {
  count = var.environment == "prod" && var.disk_size_gb > 0 ? 1 : 0

  instance_id = yandex_compute_instance.vm.id
  disk_id     = yandex_compute_disk.data_disk[0].id
}

# Optional: Security group for the VM
resource "yandex_vpc_security_group" "vm_sg" {
  count = var.environment == "prod" ? 1 : 0

  name        = "${local.full_vm_name}-sg"
  description = "Security group for ${local.full_vm_name}"
  network_id  = data.yandex_vpc_subnet.selected.network_id

  ingress {
    protocol       = "TCP"
    description    = "SSH"
    v4_cidr_blocks = var.environment == "prod" ? ["10.0.0.0/8"] : ["0.0.0.0/0"]
    port           = 22
  }

  ingress {
    protocol       = "TCP"
    description    = "HTTP"
    v4_cidr_blocks = var.environment == "prod" ? ["10.0.0.0/8"] : ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    protocol       = "TCP"
    description    = "HTTPS"
    v4_cidr_blocks = var.environment == "prod" ? ["10.0.0.0/8"] : ["0.0.0.0/0"]
    port           = 443
  }

  egress {
    protocol       = "ANY"
    description    = "All outbound traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  labels = local.common_tags
}

# Data source to get subnet information
data "yandex_vpc_subnet" "selected" {
  subnet_id = var.subnet_id
}
