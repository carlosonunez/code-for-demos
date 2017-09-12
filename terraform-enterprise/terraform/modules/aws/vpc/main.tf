resource "aws_vpc" "vpc" {
  cidr_block = "${var.cidr_block}"

  tags {
    Environment = "${var.aws_environment}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Environment = "${var.aws_environment}"
  }
}
