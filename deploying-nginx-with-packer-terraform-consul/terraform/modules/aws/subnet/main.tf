resource "aws_subnet" "subnet" {
  vpc_id     = "${var.vpc_id}"
  cidr_block = "${var.cidr_block}"

  tags {
    Name        = "${var.subnet_name}"
    Environment = "${var.aws_environment}"
  }
}

resource "aws_route_table" "internet_enabled_route_table" {
  count  = "${var.enable_internet_access == true ? 1 : 0}"
  vpc_id = "${var.vpc_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${var.aws_internet_gateway_id}"
  }

  tags {
    Environment = "${var.aws_environment}"
    Purpose     = "${format("Route table for inbound/outbound internet traffic for %s",var.subnet_name)}"
  }
}

resource "aws_route_table_association" "internet_link" {
  count  = "${var.enable_internet_access == true ? 1 : 0}"
  subnet_id = "${aws_subnet.subnet.id}"
  route_table_id = "${aws_route_table.internet_enabled_route_table.id}" 
}
