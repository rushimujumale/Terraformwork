resource "aws_route53_zone" "example" {
  name    = var.domain_name
  comment = var.comment

  vpc {
    vpc_id     = var.vpc_id
    is_private = var.is_private
  }
}

output "zone_id" {
  value = aws_route53_zone.example.zone_id
}