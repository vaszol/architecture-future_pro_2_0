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
  description = "Name of the VM in staging environment"
  type        = string
  default     = "stage-server"
}

variable "vcpu_count" {
  description = "Number of vCPUs for staging VM"
  type        = number
  default     = 4
}

variable "ram_size_mb" {
  description = "RAM size in MB for staging VM"
  type        = number
  default     = 8192
}

variable "disk_size_gb" {
  description = "Additional disk size for staging VM"
  type        = number
  default     = 100
}

variable "disk_type" {
  description = "Disk type for staging VM"
  type        = string
  default     = "ssd"
}

variable "subnet_id" {
  description = "Subnet ID for staging VM"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key for staging VM access"
  type        = string
  sensitive   = true
}

variable "owner" {
  description = "Owner of the resources"
  type        = string
  default     = "stage-team"
}