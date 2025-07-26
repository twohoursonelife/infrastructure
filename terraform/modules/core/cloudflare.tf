resource "cloudflare_account" "twohoursonelife" {
  name = "Two Hours One Life"
  type = "standard"

  settings = {
    abuse_contact_email = "admin@twohoursonelife.com"
    enforce_twofactor   = true
  }

  lifecycle {
    # https://github.com/cloudflare/terraform-provider-cloudflare/issues/5716
    ignore_changes = [type]
  }
}

resource "cloudflare_zone" "twohoursonelife" {
  name = "twohoursonelife.com"
  type = "full"

  account = {
    id = cloudflare_account.twohoursonelife.id
  }
}

###
# Records
###

# website
resource "cloudflare_dns_record" "website" {
  zone_id = cloudflare_zone.twohoursonelife.id

  name    = "twohoursonelife.com"
  type    = "A"
  ttl     = 1
  content = "151.101.130.159"
  proxied = true
}

# wesbite www
resource "cloudflare_dns_record" "website_www" {
  zone_id = cloudflare_zone.twohoursonelife.id

  name    = "www.twohoursonelife.com"
  type    = "CNAME"
  ttl     = 1
  content = "twohoursonelife.com"
  proxied = true
}

# game server
resource "cloudflare_dns_record" "play" {
  zone_id = cloudflare_zone.twohoursonelife.id

  name    = "play.twohoursonelife.com"
  type    = "A"
  ttl     = 1
  content = digitalocean_reserved_ip.play.ip_address
}

# web backend
resource "cloudflare_dns_record" "web" {
  zone_id = cloudflare_zone.twohoursonelife.id

  name    = "web.twohoursonelife.com"
  type    = "A"
  ttl     = 1
  content = digitalocean_reserved_ip.play.ip_address
}

# twotech
resource "cloudflare_dns_record" "twotech" {
  zone_id = cloudflare_zone.twohoursonelife.id

  name    = "twotech.twohoursonelife.com"
  type    = "A"
  ttl     = 1
  content = "44.216.122.169"
  proxied = true
}

# twotech edge
resource "cloudflare_dns_record" "twotech_edge" {
  zone_id = cloudflare_zone.twohoursonelife.id

  name    = "edge.twotech.twohoursonelife.com"
  type    = "A"
  ttl     = 1
  content = "44.216.122.169"
  proxied = true
}

# database
resource "cloudflare_dns_record" "database" {
  zone_id = cloudflare_zone.twohoursonelife.id

  name    = "db.twohoursonelife.com"
  type    = "CNAME"
  ttl     = 1
  content = "twohoursonelife.cbqw2zmra9kl.us-east-1.rds.amazonaws.com"
}

# email
resource "cloudflare_dns_record" "email1" {
  zone_id = cloudflare_zone.twohoursonelife.id

  name     = "twohoursonelife.com"
  type     = "MX"
  ttl      = 1
  content  = "mx.zoho.com"
  priority = 10
}

resource "cloudflare_dns_record" "email2" {
  zone_id = cloudflare_zone.twohoursonelife.id

  name     = "twohoursonelife.com"
  type     = "MX"
  ttl      = 1
  content  = "mx2.zoho.com"
  priority = 20
}

resource "cloudflare_dns_record" "email3" {
  zone_id = cloudflare_zone.twohoursonelife.id

  name     = "twohoursonelife.com"
  type     = "MX"
  ttl      = 1
  content  = "mx3.zoho.com"
  priority = 50
}

# email dmarc
resource "cloudflare_dns_record" "dmarc" {
  zone_id = cloudflare_zone.twohoursonelife.id

  name    = "_dmarc.twohoursonelife.com"
  type    = "TXT"
  ttl     = 1
  content = "\"v=DMARC1; p=none; rua=mailto:admin@twohoursonelife.com; ruf=mailto:admin@twohoursonelife.com; sp=none; adkim=s; aspf=s\""
}

# email spf
resource "cloudflare_dns_record" "spf" {
  zone_id = cloudflare_zone.twohoursonelife.id

  name    = "twohoursonelife.com"
  type    = "TXT"
  ttl     = 1
  content = "\"v=spf1 include:zohomail.com ~all\""
}

# email dkim
resource "cloudflare_dns_record" "dkim" {
  zone_id = cloudflare_zone.twohoursonelife.id

  name    = "twohoursonelife._domainkey.twohoursonelife.com"
  type    = "TXT"
  ttl     = 1
  content = "\"v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCW0lE567VjUgHnMVUFNZtik3dRePXj6qcYs7+yPEEp9jYlvWVMjWovvSmWEt4VUbSG1FYOTnYJnbJm72821htE1Wg6elZLZ0UrpbSzti8DqxUHVa79YZ55hzf4H4VT+s5JDLw/DHwLQMfWS1xSx2CyPCadRT+PwNwnz+cFLbzDbwIDAQAB\""
}

# google site verification
resource "cloudflare_dns_record" "txt_google" {
  zone_id = cloudflare_zone.twohoursonelife.id

  name    = "twohoursonelife.com"
  type    = "TXT"
  ttl     = 1
  content = "\"google-site-verification=lXL6lZZDqy1MW4YmswjvD5iHY1oJ4C-V8cfc0KyGS40\""
}
