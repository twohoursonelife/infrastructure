resource "digitalocean_droplet" "play" {
  name = "play.twohoursonelife.com"

  region = "nyc3"
  size   = "s-2vcpu-4gb-120gb-intel"
  image  = "ubuntu-24-04-x64"

  backups    = true # Lets work on self managing this later
  monitoring = true
  user_data  = file("${path.module}/cloud-config.yml")

  # Manually managed in UI
  ssh_keys = [
    "9c:f5:b6:ad:26:64:31:4d:77:36:3e:28:d3:3e:9d:3a",
    "5b:42:4a:e0:ac:fc:a4:fa:81:7d:39:7b:b7:82:cc:bd"
  ]

  lifecycle {
    ignore_changes = [user_data]
  }
}


resource "digitalocean_reserved_ip" "play" {
  region = "nyc3"
}

resource "digitalocean_reserved_ip_assignment" "play" {
  ip_address = digitalocean_reserved_ip.play.ip_address
  droplet_id = digitalocean_droplet.play.id
}
