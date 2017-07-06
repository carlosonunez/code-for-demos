data "aws_ami" "coreos" {
  most_recent = true
  filter {
    name = "owner-id"
    values = [ "595879546273" ]
  }
  filter {
    name = "virtualization-type"
    values = [ "hvm" ]
  }
  filter {
    name = "name"
    values = [ "CoreOS-stable*" ]
  }
}

resource "aws_security_group" "ucp_manager" {
  name = "ucp_manager-sg"
  description = "Security group for UCP managers. Managed by Terraform."
  vpc_id = "${var.aws_vpc_id}"
  ingress {
    self = true
    from_port = 0
    to_port = 0
    protocol = -1
  }
}

resource "aws_security_group" "ucp_manager_lb" {
  depends_on = [ "aws_security_group.ucp_manager" ]
  name = "ucp-manager-lb-sg"
  description = "Security group for load balancer in front of UCP managers. Enables external access to UCP. Managed by Terraform."
  vpc_id = "${var.aws_vpc_id}"
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    security_groups = [ "${aws_security_group.ucp_manager.id}" ]
  }
}

resource "aws_instance" "ucp_manager_a" {
  depends_on = [
    "aws_security_group.ucp_manager",
    "aws_security_group.ucp_manager_lb"
  ]
  ami = "${data.aws_ami.coreos.id}"
  availability_zone = "${format("%sa", var.aws_region)}" 
  instance_type = "${var.aws_ec2_instance_size}"
  key_name = "${var.aws_environment_name}"
  security_groups = [
    "${var.aws_vpc_ssh_access_policy_sg_id}",
    "${aws_security_group.ucp_manager.id}"
  ]
  tags = {
    Name = "ucp-manager"
    Environment = "${var.aws_environment_name}"
  }
  root_block_device = {
    volume_size = 8
    delete_on_termination = true
  }
}

resource "aws_instance" "ucp_manager_b" {
  depends_on = [
    "aws_security_group.ucp_manager",
    "aws_security_group.ucp_manager_lb"
  ]
  count = "${var.number_of_aws_availability_zones_to_use == 2 ? 1 : 0}"
  ami = "${data.aws_ami.coreos.id}"
  availability_zone = "${format("%sb", var.aws_region)}" 
  instance_type = "${var.aws_ec2_instance_size}"
  key_name = "${var.aws_environment_name}"
  security_groups = [
    "${var.aws_vpc_ssh_access_policy_sg_id}",
    "${aws_security_group.ucp_manager.id}"
  ]
  tags = {
    Name = "ucp-manager"
    Environment = "${var.aws_environment_name}"
  }
  root_block_device = {
    volume_size = 8
    delete_on_termination = true
  }
}

resource "aws_instance" "ucp_manager_c" {
  depends_on = [
    "aws_security_group.ucp_manager",
    "aws_security_group.ucp_manager_lb"
  ]
  count = "${var.number_of_aws_availability_zones_to_use > 2 ? 1 : 0}"
  ami = "${data.aws_ami.coreos.id}"
  availability_zone = "${format("%sc", var.aws_region)}" 
  instance_type = "${var.aws_ec2_instance_size}"
  key_name = "${var.aws_environment_name}"
  security_groups = [
    "${var.aws_vpc_ssh_access_policy_sg_id}",
    "${aws_security_group.ucp_manager.id}"
  ]
  tags = {
    Name = "ucp-manager"
    Environment = "${var.aws_environment_name}"
  }
  root_block_device = {
    volume_size = 8
    delete_on_termination = true
  }
}

/* Terraform doesn't have very good semantics for expressing things that
are dynamically created during a plan, such as intermediate variables. Given
that our ELB needs to know in advance which AZs it will be serving traffic to,
but that list of AZs depends on the number_of_azs_to_use variable, this affects
us in that there's no immediate way of modifying the list of AZs provided
into the elb resource.

So we hack around it by creating three load balancer resources and setting a condition
on which to use depending on the number_of_azs_to_use parameter. */
