terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "opentofu/aws"
      version = ">= 6.0.0"
    }
    tls = {
      source  = "opentofu/tls"
      version = ">= 4.0.0"
    }
    local = {
      source  = "opentofu/local"
      version = ">= 2.0.0"
    }
  }
}
