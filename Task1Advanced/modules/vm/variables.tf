variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
}

variable "vcpu_count" {
  description = "Number of vCPUs for the VM"
  type        = number
  default     = 2
}

variable "ram_size_mb" {
  description = "RAM size in MB for the VM"
  type        = number
  default     = 4096
}

variable "disk_size_gb" {
  description = "Size of the additional disk in GB"
  type        = number
  default     = 50
}

variable "disk_type" {
  description = "Type of the disk (e.g., 'standard', 'ssd')"
  type        = string
  default     = "standard"
}

variable "subnet_id" {
  description = "ID of the subnet where the VM will be deployed"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string
  sensitive   = true
}

variable "environment" {
  description = "Environment name (dev, stage, prod)"
  type        = string
}

variable "os_image_id" {
  description = "ID of the OS image to use for the VM"
  type        = string
  default     = "ubuntu-2204-lts"
}

variable "availability_zone" {
  description = "Availability zone for the VM"
  type        = string
  default     = "ru-central1-a"
}

variable "platform_id" {
  description = "Platform ID for the VM (standard-v1, standard-v2, etc.)"
  type        = string
  default     = "standard-v2"
}

variable "boot_disk_size_gb" {
  description = "Boot disk size in GB"
  type        = number
  default     = 30
}

variable "boot_disk_type" {
  description = "Boot disk type"
  type        = string
  default     = "network-hdd"
}

variable "tags" {
  description = "Tags to assign to the VM"
  type        = map(string)
  default     = {}
}
