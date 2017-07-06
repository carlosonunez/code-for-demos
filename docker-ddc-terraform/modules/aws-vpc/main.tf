resource "aws_vpc" "vpc" {
  cidr_block = "${var.aws_vpc_cidr_block}"
  tags = {
    Domain = "${var.aws_vpc_dns_domain}"
    Environment = "${var.aws_vpc_environment_name}"
  }
}

output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}
