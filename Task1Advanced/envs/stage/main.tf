terraform {
  required_version = ">= 1.0"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.75"
    }
  }

  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "yandex" {
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}

module "stage_vm" {
  source = "../../modules/vm"

  vm_name        = var.vm_name
  environment    = "stage"
  vcpu_count     = var.vcpu_count
  ram_size_mb    = var.ram_size_mb
  disk_size_gb   = var.disk_size_gb
  disk_type      = var.disk_type
  subnet_id      = var.subnet_id
  ssh_public_key = var.ssh_public_key

  tags = {
    Purpose    = "Staging"
    Owner      = var.owner
    AutoShutdown = "false"
  }
}

output "vm_details" {
  value = module.stage_vm.all_vm_details
}