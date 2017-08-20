module "vpc" {
  source          = "./modules/aws/vpc"
  cidr_block      = "${var.aws_vpc_cidr_block}"
  aws_environment = "${var.environment_name}"
}

resource "aws_key_pair" "ec2_key_for_environment" {
  key_name   = "${var.environment_name}"
  public_key = "${var.environment_public_key}"
}

module "management-subnet" {
  source                  = "./modules/aws/subnet"
  subnet_name             = "management"
  vpc_id                  = "${module.vpc.vpc_id}"
  cidr_block              = "${var.aws_mgmt_subnet_cidr_block}"
  aws_environment         = "${var.environment_name}"
  enable_internet_access  = "true"
  aws_internet_gateway_id = "${module.vpc.internet_gateway_id}"
}

module "public_instances_subnet" {
  source                  = "./modules/aws/subnet"
  subnet_name             = "public_instances"
  vpc_id                  = "${module.vpc.vpc_id}"
  cidr_block              = "${var.aws_public_instances_subnet_cidr_block}"
  aws_environment         = "${var.environment_name}"
  enable_internet_access  = "true"
  aws_internet_gateway_id = "${module.vpc.internet_gateway_id}"
}

module "consul_datacenter" {
  source          = "./modules/aws/ec2_instance/consul_server"
  count           = "${var.number_of_consul_servers}"
  ami_id          = "${var.consul_server_ami_id}"
  instance_type   = "${var.consul_server_instance_type}"
  key_name        = "${var.environment_name}"
  vpc_id          = "${module.vpc.vpc_id}"
  subnet_id       = "${module.public_instances_subnet.subnet_id}"
  aws_environment = "${var.environment_name}"
}

module "web_server" {
  source          = "./modules/aws/ec2_instance/web"
  count           = "${var.number_of_web_servers}"
  ami_id          = "${var.web_server_ami_id}"
  instance_type   = "${var.web_server_instance_type}"
  key_name        = "${var.environment_name}"
  vpc_id          = "${module.vpc.vpc_id}"
  subnet_id       = "${module.public_instances_subnet.subnet_id}"
  aws_environment = "${var.environment_name}"
}
