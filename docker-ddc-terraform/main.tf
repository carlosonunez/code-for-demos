module "vpc" {
  source = "./modules/aws-vpc"
  aws_vpc_cidr_block = "${var.aws_vpc_cidr_block}"
  aws_vpc_dns_domain = "${var.dns_zone_to_use}"
  aws_environment_name = "${var.environment_name}"
}

module "dns_zone" {
  source = "./modules/aws-route53-hosted_zone"
  aws_route53_zone_name = "${var.dns_zone_to_use}"
  aws_environment_name = "${var.environment_name}"
}
