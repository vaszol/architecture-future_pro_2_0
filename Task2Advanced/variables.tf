variable "cloud_id" {
  description = "Yandex Cloud ID"
  type        = string
  sensitive   = true
}

variable "folder_id" {
  description = "Yandex Cloud Folder ID"
  type        = string
  sensitive   = true
}

variable "vm_name" {
  description = "VM name"
  type        = string
  default     = "ci-cd-vm"
}

variable "vcpu_count" {
  description = "Number of vCPUs"
  type        = number
  default     = 2
}

variable "ram_size_mb" {
  description = "RAM size in MB"
  type        = number
  default     = 4096
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key"
  type        = string
  sensitive   = true
}