resource "aws_vpc" "vpc" {
  cidr_block = "${var.aws_vpc_cidr_block}"
  tags = {
    Domain = "${var.aws_vpc_dns_domain}"
    Environment = "${var.aws_environment_name}"
  }
}
