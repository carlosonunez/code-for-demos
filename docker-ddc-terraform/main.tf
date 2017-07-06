module "vpc" {
  source = "./modules/aws-vpc"
  aws_vpc_cidr_block = "${var.aws_vpc_cidr_block}"
  aws_vpc_domain = "${var.dns_zone_to_use}"
  aws_vpc_environment_name = "${var.environment_name}"
}
