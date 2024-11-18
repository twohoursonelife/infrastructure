resource "digitalocean_domain" "main" {
  name = var.domain
}

#
# NS records
#

resource "digitalocean_record" "ns1" {
  domain = digitalocean_domain.main.id
  type   = "NS"
  name   = "@"
  value  = "ns1.digitalocean.com."
  ttl    = 86400
}

resource "digitalocean_record" "ns2" {
  domain = digitalocean_domain.main.id
  type   = "NS"
  name   = "@"
  value  = "ns2.digitalocean.com."
  ttl    = 86400
}

resource "digitalocean_record" "ns3" {
  domain = digitalocean_domain.main.id
  type   = "NS"
  name   = "@"
  value  = "ns3.digitalocean.com."
  ttl    = 86400
}


#
# NS records
#

resource "digitalocean_record" "dev_ns1" {
  domain = digitalocean_domain.main.id
  type   = "NS"
  name   = "dev"
  value  = "ns1.digitalocean.com."
  ttl    = 86400
}

resource "digitalocean_record" "dev_ns2" {
  domain = digitalocean_domain.main.id
  type   = "NS"
  name   = "dev"
  value  = "ns2.digitalocean.com."
  ttl    = 86400
}

resource "digitalocean_record" "dev_ns3" {
  domain = digitalocean_domain.main.id
  type   = "NS"
  name   = "dev"
  value  = "ns3.digitalocean.com."
  ttl    = 86400
}


#
# Wesbite records
#

resource "digitalocean_record" "website" {
  domain = digitalocean_domain.main.id
  type   = "A"
  name   = "@"
  value  = "151.101.130.159"
  ttl    = 3600
}

resource "digitalocean_record" "website_www" {
  domain = digitalocean_domain.main.id
  type   = "CNAME"
  name   = "www"
  value  = "twohoursonelife.com."
  ttl    = 43200
}


#
# Game server records
#

resource "digitalocean_record" "play" {
  domain = digitalocean_domain.main.id
  type   = "A"
  name   = "play"
  value  = "45.55.120.214"
  ttl    = 300
}

resource "digitalocean_record" "web" {
  domain = digitalocean_domain.main.id
  type   = "A"
  name   = "web"
  value  = "45.55.120.214"
  ttl    = 3600
}

resource "digitalocean_record" "database" {
  domain = digitalocean_domain.main.id
  type   = "CNAME"
  name   = "db"
  value  = "twohoursonelife.cbqw2zmra9kl.us-east-1.rds.amazonaws.com."
  ttl    = 43200
}


#
# twotech records
#

resource "digitalocean_record" "twotech" {
  domain = digitalocean_domain.main.id
  type   = "A"
  name   = "twotech"
  value  = "44.216.122.169"
  ttl    = 3600
}

resource "digitalocean_record" "twotech_edge" {
  domain = digitalocean_domain.main.id
  type   = "A"
  name   = "edge.twotech"
  value  = "44.216.122.169"
  ttl    = 3600
}


#
# Mail records
#

resource "digitalocean_record" "mx1" {
  domain   = digitalocean_domain.main.id
  type     = "MX"
  name     = "@"
  value    = "mx1.privateemail.com."
  ttl      = 14400
  priority = 10
}

resource "digitalocean_record" "mx2" {
  domain   = digitalocean_domain.main.id
  type     = "MX"
  name     = "@"
  value    = "mx2.privateemail.com."
  ttl      = 14400
  priority = 10
}

resource "digitalocean_record" "mail_spf" {
  domain = digitalocean_domain.main.id
  type   = "TXT"
  name   = "@"
  value  = "v=spf1 include:spf.privateemail.com ~all"
  ttl    = 3600
}


#
# Verification records
#

resource "digitalocean_record" "verification" {
  domain = digitalocean_domain.main.id
  type   = "TXT"
  name   = "@"
  value  = "google-site-verification=lXL6lZZDqy1MW4YmswjvD5iHY1oJ4C-V8cfc0KyGS40"
  ttl    = 3600
}

# Webhost Flywheel
resource "digitalocean_record" "website_verification" {
  domain = digitalocean_domain.main.id
  type   = "TXT"
  name   = "domain-verification"
  value  = "baf5f387-281b-4998-b75f-15ad97f592f3"
}
