terraform {
  backend "local" {
    path = "terraform.tfstate"
  }

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  # Set via environment variable DIGITALOCEAN_TOKEN
  # token = ""
}
