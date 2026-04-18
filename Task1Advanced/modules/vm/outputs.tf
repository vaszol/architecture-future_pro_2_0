output "vm_id" {
  description = "ID of the created virtual machine"
  value       = yandex_compute_instance.vm.id
}

output "vm_name" {
  description = "Name of the created virtual machine"
  value       = yandex_compute_instance.vm.name
}

output "external_ip" {
  description = "External IP address of the VM"
  value       = yandex_compute_instance.vm.network_interface.0.nat_ip_address
}

output "internal_ip" {
  description = "Internal IP address of the VM"
  value       = yandex_compute_instance.vm.network_interface.0.ip_address
}

output "disk_ids" {
  description = "IDs of the disks attached to the VM"
  value = compact([
    yandex_compute_instance.vm.boot_disk.0.disk_id,
    try(yandex_compute_disk.data_disk[0].id, null),
    try(yandex_compute_instance.vm.secondary_disk[0].disk_id, null)
  ])
}

output "security_group_id" {
  description = "ID of the security group (if created)"
  value       = try(yandex_vpc_security_group.vm_sg[0].id, null)
}

output "vm_fqdn" {
  description = "FQDN of the virtual machine"
  value       = "${yandex_compute_instance.vm.name}.ru-central1.internal"
}

output "vm_status" {
  description = "Status of the virtual machine"
  value       = yandex_compute_instance.vm.status
}

output "all_vm_details" {
  description = "Complete VM details"
  value = {
    id           = yandex_compute_instance.vm.id
    name         = yandex_compute_instance.vm.name
    external_ip  = yandex_compute_instance.vm.network_interface.0.nat_ip_address
    internal_ip  = yandex_compute_instance.vm.network_interface.0.ip_address
    status       = yandex_compute_instance.vm.status
    environment  = var.environment
    resources    = {
      cores  = var.vcpu_count
      memory = var.ram_size_mb
    }
  }
  sensitive = false
}
