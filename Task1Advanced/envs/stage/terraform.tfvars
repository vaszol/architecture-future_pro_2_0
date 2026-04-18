# Staging environment configuration
cloud_id     = "your-cloud-id-here"
folder_id    = "your-folder-id-here"
zone         = "ru-central1-b"
subnet_id    = "your-stage-subnet-id"
owner        = "stage-team"

# VM configuration for staging
vm_name       = "stage-app-server"
vcpu_count    = 4
ram_size_mb   = 8192
disk_size_gb  = 100
disk_type     = "ssd"

# SSH public key
ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQ..."