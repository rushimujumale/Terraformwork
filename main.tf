module "hosted_zone" {
  source      = "./modules/hosted-zone"
  domain_name = var.domain_name
  comment     = var.comment
  vpc_id      = var.vpc_id
  is_private  = var.is_private
}

output "zone_id" {
  value = module.hosted_zone.zone_id
}