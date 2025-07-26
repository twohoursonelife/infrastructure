resource "digitalocean_vpc" "main" {
  name     = "default-nyc3"
  region   = "nyc3"
  ip_range = "10.132.0.0/16"
}
