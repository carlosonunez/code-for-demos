resource "aws_security_group" "web_servers" {
  name        = "${format("web_server-%s-sg",var.aws_environment)}"
  description = "Security group description for web servers. Completely open for our demo. DON'T DO THIS FOR REAL ENVIRONMENTS."

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

resource "aws_instance" "instance" {
  ami                    = "${var.ami_id}"
  instance_type          = "${var.instance_type}"
  vpc_security_group_ids = ["${aws_security_group.web_servers.id}"]
  instance_type          = "${var.instance_type}"
  key_name               = "${var.key_name}"
  subnet_id              = "${var.subnet_id}"

  root_block_device {
    volume_size = "${var.disk_size}"
  }
}
