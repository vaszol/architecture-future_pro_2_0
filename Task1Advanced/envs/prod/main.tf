terraform {
  required_version = ">= 1.0"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.75"
    }
  }

  backend "s3" {
    # S3 backend configuration for production state management
    bucket = "prod-terraform-state"
    key    = "prod/vm/terraform.tfstate"
    region = "ru-central1"
  }
}

provider "yandex" {
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}

module "prod_vm" {
  source = "../../modules/vm"

  vm_name           = var.vm_name
  environment       = "prod"
  vcpu_count        = var.vcpu_count
  ram_size_mb       = var.ram_size_mb
  disk_size_gb      = var.disk_size_gb
  disk_type         = var.disk_type
  subnet_id         = var.subnet_id
  ssh_public_key    = var.ssh_public_key
  boot_disk_size_gb = 100
  boot_disk_type    = "network-ssd"
  platform_id       = "standard-v3"

  tags = {
    Purpose       = "Production"
    Owner         = var.owner
    AutoShutdown  = "false"
    Backup        = "enabled"
    Monitoring    = "enabled"
  }
}

output "vm_details" {
  value = module.prod_vm.all_vm_details
}