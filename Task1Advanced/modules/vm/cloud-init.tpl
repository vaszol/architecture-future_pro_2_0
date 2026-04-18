#cloud-config
package_update: true
package_upgrade: ${environment == "prod" ? true : false}

packages:
  - htop
  - git
  - curl
  - wget
  - net-tools

runcmd:
  - echo "VM: ${vm_name}" > /etc/hostname
  - hostname ${vm_name}
  - echo "Environment: ${environment}" > /etc/environment_info
  - systemctl enable systemd-networkd
  - systemctl start systemd-networkd

write_files:
  - path: /etc/motd
    content: |
      Welcome to ${vm_name}
      Environment: ${environment}
      Managed by Terraform VM Module
    permissions: '0644'