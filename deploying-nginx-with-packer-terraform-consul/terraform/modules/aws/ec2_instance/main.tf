resource "aws_instance" "instance" {
  ami = "${var.ami_id}"
  instance_type = "${var.instance_type}"
  vpc_security_group_ids = "${var.security_groups}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_name}"
  subnet_id = "${var.subnet_id}"
  root_block_device {
    volume_size = "${var.disk_size}"
  }
}
