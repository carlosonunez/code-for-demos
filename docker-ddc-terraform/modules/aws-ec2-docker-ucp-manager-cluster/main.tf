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
  /* TODO: See if setting egress to the LB only affects operations. */
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

resource "aws_subnet" "manager_subnet_a" {
  vpc_id = "${var.aws_vpc_id}"
  cidr_block = "${var.subnet_cidr_block}"
  availability_zone = "${format("%sa", var.aws_region)}"
}

resource "aws_subnet" "manager_subnet_b" {
  count = "${var.number_of_aws_availability_zones_to_use > 1 ? 1 : 0}"
  vpc_id = "${var.aws_vpc_id}"
  cidr_block = "${var.subnet_cidr_block}"
  availability_zone = "${format("%sb", var.aws_region)}"
}

resource "aws_subnet" "manager_subnet_c" {
  count = "${var.number_of_aws_availability_zones_to_use > 2 ? 1 : 0}"
  vpc_id = "${var.aws_vpc_id}"
  cidr_block = "${var.subnet_cidr_block}"
  availability_zone = "${format("%sc", var.aws_region)}"
}

resource "aws_instance" "ucp_manager_a" {
  depends_on = [
    "aws_security_group.ucp_manager",
    "aws_security_group.ucp_manager_lb",
    "aws_subnet.manager_subnet_a"
  ]
  subnet_id = "${aws_subnet.manager_subnet_a.id}"
  ami = "${data.aws_ami.coreos.id}"
  availability_zone = "${format("%sa", var.aws_region)}" 
  instance_type = "${var.aws_ec2_instance_size}"
  key_name = "${var.aws_environment_name}"
  vpc_security_group_ids = [
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
    "aws_security_group.ucp_manager_lb",
    "aws_subnet.manager_subnet_b"
  ]
  subnet_id = "${aws_subnet.manager_subnet_b.id}"
  count = "${var.number_of_aws_availability_zones_to_use > 1 ? 1 : 0}"
  ami = "${data.aws_ami.coreos.id}"
  availability_zone = "${format("%sb", var.aws_region)}" 
  instance_type = "${var.aws_ec2_instance_size}"
  key_name = "${var.aws_environment_name}"
  vpc_security_group_ids = [
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
    "aws_security_group.ucp_manager_lb",
    "aws_subnet.manager_subnet_c"
  ]
  subnet_id = "${aws_subnet.manager_subnet_c.id}"
  count = "${var.number_of_aws_availability_zones_to_use > 2 ? 1 : 0}"
  ami = "${data.aws_ami.coreos.id}"
  availability_zone = "${format("%sc", var.aws_region)}" 
  instance_type = "${var.aws_ec2_instance_size}"
  key_name = "${var.aws_environment_name}"
  vpc_security_group_ids = [
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
on which one to use depending on the number_of_azs_to_use parameter. */
resource "aws_elb" "ucp_manager_elb_single_az" {
  depends_on = [
    "aws_instance.ucp_manager_a"
  ]
  count = "${var.number_of_aws_availability_zones_to_use <= 1 ? 1 : 0}"
  name = "ucp-manager-lb"
  availability_zones = ["${format("%sa", var.aws_region)}"]
  security_groups = [ "${aws_security_group.ucp_manager_lb.id}" ]
  instances = [ "${aws_instance.ucp_manager_a.id}" ]

  /* Docker does not recommend having the ELB terminate HTTPS connections, as
  the managers use mutual TLS between each other and doing so breaks
  this trust. See here for more details: 
  https://docs.docker.com/datacenter/ucp/2.1/guides/admin/configure/use-a-load-balancer/#load-balancing-on-ucp */
  listener {
    instance_port = "${var.load_balancer_origin_port}"
    instance_protocol = "${var.load_balancer_origin_protocol}"
    lb_port = "${var.load_balancer_listening_port}"
    lb_protocol = "${var.load_balancer_listening_protocol}"
  }

  health_check {
    healthy_threshold = "${var.load_balancer_number_of_checks_until_healthy}"
    unhealthy_threshold = "${var.load_balancer_number_of_checks_until_not_healthy}"
    target = "${var.load_balancer_target}"
    interval = "${var.load_balancer_health_check_interval_in_seconds}"
    timeout = "${var.load_balancer_health_check_timeout_in_seconds}"
  }
}

resource "aws_elb" "ucp_manager_elb_dual_az" {
  depends_on = [
    "aws_instance.ucp_manager_a",
    "aws_instance.ucp_manager_b"
  ]
  count = "${var.number_of_aws_availability_zones_to_use == 2 ? 1 : 0}"
  availability_zones = ["${format("%sa", var.aws_region)}", 
                        "${format("%sb", var.aws_region)}"]
  security_groups = [ "${aws_security_group.ucp_manager_lb.id}" ]
  instances = [ "${aws_instance.ucp_manager_a.id}",
                "${aws_instance.ucp_manager_b.id}" ]

  /* Docker does not recommend having the ELB terminate HTTPS connections, as
  the managers use mutual TLS between each other and doing so breaks
  this trust. See here for more details: 
  https://docs.docker.com/datacenter/ucp/2.1/guides/admin/configure/use-a-load-balancer/#load-balancing-on-ucp */ listener {
    instance_port = "${var.load_balancer_origin_port}"
    instance_protocol = "${var.load_balancer_origin_protocol}"
    lb_port = "${var.load_balancer_listening_port}"
    lb_protocol = "${var.load_balancer_listening_protocol}"
  }

  health_check {
    healthy_threshold = "${var.load_balancer_number_of_checks_until_healthy}"
    unhealthy_threshold = "${var.load_balancer_number_of_checks_until_not_healthy}"
    target = "${var.load_balancer_target}"
    interval = "${var.load_balancer_health_check_interval_in_seconds}"
    timeout = "${var.load_balancer_health_check_timeout_in_seconds}"
  }
}

resource "aws_elb" "ucp_manager_elb_tri_az" {
  depends_on = [
    "aws_instance.ucp_manager_a",
    "aws_instance.ucp_manager_b",
    "aws_instance.ucp_manager_c"
  ]
  count = "${var.number_of_aws_availability_zones_to_use == 3 ? 1 : 0}"
  availability_zones = ["${format("%sa", var.aws_region)}",
                        "${format("%sb", var.aws_region)}",
                        "${format("%sc", var.aws_region)}"]
  security_groups = [ "${aws_security_group.ucp_manager_lb.id}" ]
  instances = [ "${aws_instance.ucp_manager_a.id}",
                "${aws_instance.ucp_manager_b.id}",
                "${aws_instance.ucp_manager_c.id}" ]

  /* Docker does not recommend having the ELB terminate HTTPS connections, as
  the managers use mutual TLS between each other and doing so breaks
  this trust. See here for more details: 
  https://docs.docker.com/datacenter/ucp/2.1/guides/admin/configure/use-a-load-balancer/#load-balancing-on-ucp */
  listener {
    instance_port = "${var.load_balancer_origin_port}"
    instance_protocol = "${var.load_balancer_origin_protocol}"
    lb_port = "${var.load_balancer_listening_port}"
    lb_protocol = "${var.load_balancer_listening_protocol}"
  }

  health_check {
    healthy_threshold = "${var.load_balancer_number_of_checks_until_healthy}"
    unhealthy_threshold = "${var.load_balancer_number_of_checks_until_not_healthy}"
    target = "${var.load_balancer_target}"
    interval = "${var.load_balancer_health_check_interval_in_seconds}"
    timeout = "${var.load_balancer_health_check_timeout_in_seconds}"
  }
}
