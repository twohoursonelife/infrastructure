resource "digitalocean_spaces_bucket" "twohoursonelife" {
  name   = "twohoursonelife"
  region = "nyc3"
  acl    = "private"
}
