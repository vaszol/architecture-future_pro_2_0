# Production environment configuration
cloud_id     = "your-prod-cloud-id-here"
folder_id    = "your-prod-folder-id-here"
zone         = "ru-central1-c"
subnet_id    = "your-prod-subnet-id"
owner        = "prod-team"

# VM configuration for production
vm_name       = "prod-app-server"
vcpu_count    = 8
ram_size_mb   = 32768
disk_size_gb  = 500
disk_type     = "ssd"

# SSH public key
ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQ..."