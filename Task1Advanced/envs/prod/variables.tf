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

variable "zone" {
  description = "Availability zone"
  type        = string
  default     = "ru-central1-c"
}

variable "vm_name" {
  description = "Name of the VM in production environment"
  type        = string
  default     = "prod-server"
}

variable "vcpu_count" {
  description = "Number of vCPUs for production VM"
  type        = number
  default     = 8
}

variable "ram_size_mb" {
  description = "RAM size in MB for production VM"
  type        = number
  default     = 32768
}

variable "disk_size_gb" {
  description = "Additional disk size for production VM"
  type        = number
  default     = 500
}

variable "disk_type" {
  description = "Disk type for production VM"
  type        = string
  default     = "ssd"
}

variable "subnet_id" {
  description = "Subnet ID for production VM"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key for production VM access"
  type        = string
  sensitive   = true
}

variable "owner" {
  description = "Owner of the resources"
  type        = string
  default     = "prod-team"
}