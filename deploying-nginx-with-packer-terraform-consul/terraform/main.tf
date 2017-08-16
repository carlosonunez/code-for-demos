module "vpc" {
  source = "./modules/aws/vpc"
  cidr_block = "${var.aws_vpc_cidr_block}"
  aws_environment = "${var.environment_name}"
}
