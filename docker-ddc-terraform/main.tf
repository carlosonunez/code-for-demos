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

module "ec2_key" {
  source = "./modules/aws-ec2-key"
  aws_environment_name = "${var.environment_name}"
  aws_ec2_public_key = "${var.environment_rsa_public_key}"
}
