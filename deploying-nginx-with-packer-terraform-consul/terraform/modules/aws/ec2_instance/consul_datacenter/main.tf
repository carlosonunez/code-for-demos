resource "aws_security_group" "consul_servers" {
  name        = "${format("consul_server-%s-sg",var.aws_environment)}"
  description = "Security group description for consul servers. Completely open for our demo. DO NOT DO THIS FOR REAL ENVIRONMENTS."
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "consul_servers_internal_communication" {
  name        = "${format("consul_server_internal-%s-sg",var.aws_environment)}"
  description = "Security group description for internal communication between consul servers. Completely open for our demo. DO NOT DO THIS FOR REAL ENVIRONMENTS."
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "instance" {
  count                       = "${var.count}"
  ami                         = "${var.ami_id}"
  instance_type               = "${var.instance_type}"
  vpc_security_group_ids      = ["${aws_security_group.consul_servers.id}", "${aws_security_group.consul_servers_internal_communication.id}"]
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.key_name}"
  subnet_id                   = "${var.subnet_id}"
  associate_public_ip_address = true

  root_block_device {
    volume_size = "${var.disk_size}"
  }
}
