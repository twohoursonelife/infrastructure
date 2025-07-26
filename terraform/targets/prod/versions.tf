terraform {
  required_version = "~> 1.9"

  backend "local" {
    path = "terraform.tfstate"
  }

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.0"
    }
  }
}

provider "digitalocean" {
  # Set token via environment variable DIGITALOCEAN_TOKEN
}

provider "cloudflare" {
  # Set token via environment variable CLOUDFLARE_API_TOKEN
}
