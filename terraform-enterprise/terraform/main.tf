module "vpc" {
  // Ideally, modules would be in their own separate repositories to avoid needing to
  // copy things locally. However, for this demo, we can get away with
  // using the filesystem.
  source = "./modules/aws/vpc"

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
  source               = "./modules/aws/ec2_instance/consul_datacenter"
  count                = "${var.number_of_consul_servers}"
  ami_id               = "${data.atlas_artifact.consul_image.id}"
  ami_id               = "${var.consul_server_ami_id}"
  instance_type        = "${var.consul_server_instance_type}"
  key_name             = "${var.environment_name}"
  vpc_id               = "${module.vpc.vpc_id}"
  subnet_id            = "${module.public_instances_subnet.subnet_id}"
  aws_environment      = "${var.environment_name}"
  private_key_location = "${var.private_key_location}"
  aws_access_key       = "${var.aws_access_key}"
  aws_secret_key       = "${var.aws_secret_key}"
  aws_region           = "${var.aws_region}"
}

module "web_server" {
  source          = "./modules/aws/ec2_instance/web"
  count           = "${var.number_of_web_servers}"
  ami_id          = "${data.atlas_artifact.nginx_image.id}"
  instance_type   = "${var.web_server_instance_type}"
  key_name        = "${var.environment_name}"
  vpc_id          = "${module.vpc.vpc_id}"
  subnet_id       = "${module.public_instances_subnet.subnet_id}"
  aws_environment = "${var.environment_name}"
}
