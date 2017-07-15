resource "aws_vpc" "vpc" {
  enable_dns_support = true
  enable_dns_hostnames = true
  cidr_block = "${var.aws_vpc_cidr_block}"
  tags = {
    Environment = "${var.aws_environment_name}"
  }
}

resource "aws_subnet" "management" {
  depends_on = [
    "aws_vpc.vpc" 
  ]
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${var.management_subnet_cidr_block}"
}

resource "aws_internet_gateway" "vpc_internet_gateway" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags = {
    Environment = "${var.aws_environment_name}"
  }
}

resource "aws_route_table" "vpc_route_table" {
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.vpc_internet_gateway.id}"
  }
  tags = {
    Environment = "${var.aws_environment_name}"
  }
}

resource "aws_route_table_association" "management_to_inet_route" {
  subnet_id = "${aws_subnet.management.id}"
  route_table_id = "${aws_route_table.vpc_route_table.id}"
}

resource "aws_security_group" "bastion_host" {
  depends_on = ["aws_vpc.vpc"]
  name = "vpc-bastion_host-sg"
  vpc_id = "${aws_vpc.vpc.id}"
  description = "Bastion host for instances within this VPC. Managed by Terraform. Manual changes will be reversed."
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "all_instances" {
  depends_on = ["aws_vpc.vpc"]
  name = "${format("%s-ssh-access-sg", var.aws_environment_name)}"
  description = "Access policy for instances in the environment specified. Managed by Terraform. Manual changes will be reversed."
  vpc_id = "${aws_vpc.vpc.id}"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [
      "${aws_security_group.bastion_host.id}"
    ]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${format("%s/32", var.terraform_deployer_ip)}"]
  }
}


resource "aws_instance" "bastion_host" {
  depends_on = [
    "aws_security_group.bastion_host",
    "data.aws_ami.coreos",
    "aws_subnet.management",
  ]
  associate_public_ip_address = true
  subnet_id = "${aws_subnet.management.id}"
  ami = "${data.aws_ami.coreos.id}"
  instance_type = "t2.micro"
  key_name = "${var.aws_environment_name}"
  security_groups = [
    "${aws_security_group.bastion_host.id}"
  ]
  tags = {
    Name = "bastion_host"
    Environment = "${var.aws_environment_name}"
    InstanceType = "bastion_host"
  }
  root_block_device = {
    volume_size = 8
    delete_on_termination = true
  }

  provisioner "file" {
    connection {
      type = "ssh"
      user = "core"
      private_key = "${var.aws_ec2_private_key_location}"
      agent = false
    }
    source = "${var.aws_ec2_private_key_location}"
    destination = "$HOME/.ssh/environment_private_key"
  }
}

resource "aws_route53_record" "bastion_host" {
  zone_id = "${var.aws_route53_zone_id}"
  name = "management"
  type = "CNAME"
  ttl = 1
  records = [ "${aws_instance.bastion_host.public_dns}" ]
}
