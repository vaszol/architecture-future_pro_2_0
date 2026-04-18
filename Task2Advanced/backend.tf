terraform {
  backend "s3" {
    bucket                      = "future-2-0-terraform-state"
    key                         = "terraform.tfstate"
    region                      = "ru-central1"
    endpoint                    = "https://storage.yandexcloud.net"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style            = true
  }
}