variable "cloud_id" {
  description = "Yandex Cloud ID"
  type        = string
}

variable "folder_id" {
  description = "Yandex Cloud Folder ID"
  type        = string
}

variable "zone" {
  description = "Availability zone"
  type        = string
  default     = "ru-central1-a"
}

variable "vm_name" {
  description = "Name of the VM in dev environment"
  type        = string
  default     = "dev-server"
}

variable "vcpu_count" {
  description = "Number of vCPUs for dev VM"
  type        = number
  default     = 2
}

variable "ram_size_mb" {
  description = "RAM size in MB for dev VM"
  type        = number
  default     = 4096
}

variable "disk_size_gb" {
  description = "Additional disk size for dev VM"
  type        = number
  default     = 50
}

variable "disk_type" {
  description = "Disk type for dev VM"
  type        = string
  default     = "standard"
}

variable "subnet_id" {
  description = "Subnet ID for dev VM"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key for dev VM access"
  type        = string
  sensitive   = true
}

variable "owner" {
  description = "Owner of the resources"
  type        = string
  default     = "dev-team"
}