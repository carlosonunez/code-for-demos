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

module "vpc_with_bastion_host" {
  source = "./modules/aws-vpc-with-bastion-host"
  aws_vpc_cidr_block = "${var.aws_vpc_cidr_block}"
  aws_vpc_dns_domain = "${var.dns_zone_to_use}"
  aws_environment_name = "${var.environment_name}"
  terraform_deployer_ip = "${var.terraform_deployer_ip}"
  aws_route53_zone_id = "${module.dns_zone.id}"
  management_subnet_cidr_block = "${var.management_subnet_cidr_block}"
  aws_ec2_private_key_location = "${var.aws_ec2_private_key_location}"
}

module "ucp_manager-cluster" {
  source = "./modules/aws-ec2-docker-ucp-manager-cluster"
  aws_vpc_id = "${module.vpc_with_bastion_host.vpc_id}"
  aws_vpc_route_table_id = "${module.vpc_with_bastion_host.route_table_id}"
  aws_vpc_ssh_access_policy_sg_id = "${module.vpc_with_bastion_host.default_ssh_sg_id}"
  aws_route53_zone_id = "${module.dns_zone.id}"
  number_of_aws_availability_zones_to_use = "${var.ucp_az_count}"
  aws_ec2_instance_size = "${var.ucp_manager_instance_size}"
  aws_region = "${var.aws_region}"
  aws_environment_name = "${var.environment_name}"
  subnet_cidr_block_list = "${var.docker_ucp_manager_subnet_cidr_block_list}"
  aws_ec2_private_key_location = "${var.aws_ec2_private_key_location}"
  docker_ee_repo_url = "${var.docker_ee_repo_url}"
}

module "ucp_workers" {
  source = "./modules/aws-ec2-docker-ucp-workers"
  aws_vpc_id = "${module.vpc_with_bastion_host.vpc_id}"
  aws_vpc_route_table_id = "${module.vpc_with_bastion_host.route_table_id}"
  aws_vpc_ssh_access_policy_sg_id = "${module.vpc_with_bastion_host.default_ssh_sg_id}"
  aws_route53_zone_id = "${module.dns_zone.id}"
  number_of_aws_availability_zones_to_use = "${var.ucp_az_count}"
  aws_ec2_instance_size = "${var.ucp_worker_instance_size}"
  aws_region = "${var.aws_region}"
  aws_environment_name = "${var.environment_name}"
  subnet_cidr_block_list = "${var.docker_ucp_worker_subnet_cidr_block_list}"
  aws_ec2_private_key_location = "${var.aws_ec2_private_key_location}"
  docker_ee_repo_url = "${var.docker_ee_repo_url}"
  number_of_workers_per_az = "${var.number_of_workers_per_az}"
  docker_swarm_leader_ip = "${module.ucp_manager-cluster.docker_ucp_manager_cluster_leader_ip}"
  ucp_manager_lb_security_group = "${module.ucp_manager-cluster.docker_ucp_manager_lb_security_group_id}"
  docker_ucp_security_group_id = "${module.ucp_manager-cluster.docker_ucp_cluster_security_group_id}"
  ucp_manager_elb_id = "${module.ucp_manager-cluster.ucp_manager_elb_id}"
}
