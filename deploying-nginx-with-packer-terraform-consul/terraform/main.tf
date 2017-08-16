module "vpc" {
  source          = "./modules/aws/vpc"
  cidr_block      = "${var.aws_vpc_cidr_block}"
  aws_environment = "${var.environment_name}"
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
