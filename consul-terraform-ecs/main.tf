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
