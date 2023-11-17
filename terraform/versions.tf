terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = ">= 0.13"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.4.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "3.2.1"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "4.0.4"
    }

    time = {
      source  = "hashicorp/time"
      version = "0.9.1"
    }
  }
}
