module "network" {
  source = "../../modules/network"

  domain = "twohoursonelife.com"
}

module "main" {
  source = "../../modules/main"
}
