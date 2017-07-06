module "ec2_key" {
  source = "./modules/aws-ec2-key"
  aws_environment_name = "${var.environment_name}"
  aws_ec2_public_key = "${var.environment_rsa_public_key}"
}

module "dns_zone" {
  source = "./modules/aws-route53-hosted_zone"
  aws_route53_zone_name = "${var.dns_zone_to_use}"
  aws_environment_name = "${var.environment_name}"
}

module "vpc" {
  source = "./modules/aws-vpc"
  aws_vpc_cidr_block = "${var.aws_vpc_cidr_block}"
  aws_vpc_dns_domain = "${var.dns_zone_to_use}"
  aws_environment_name = "${var.environment_name}"
  terraform_deployer_ip = "${var.terraform_deployer_ip}"
  aws_route53_zone_id = "${module.dns_zone.id}"
}

module "ucp_manager-cluster" {
  source = "./modules/aws-ec2-docker-ucp-manager-cluster"
  aws_vpc_ssh_access_policy_sg_id = "${module.vpc.ssh_sg_id}"
  aws_vpc_id = "${module.vpc.id}"
  aws_route53_zone_id = "${module.dns_zone.id}"
  number_of_aws_availability_zones_to_use = "${var.ucp_az_count}"
  aws_ec2_instance_size = "${var.ucp_manager_instance_size}"
}
