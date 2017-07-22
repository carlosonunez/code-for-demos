data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name = "owner-id"
    values = [ "099720109477" ]
  }

  filter {
    name = "virtualization-type"
    values = [ "hvm" ]
  }
  filter {
    name = "name"
    values = [ "ubuntu/images/hvm-ssd/ubuntu-zesty*" ]
  }
}

resource "aws_subnet" "worker_subnet_a" {
  vpc_id = "${var.aws_vpc_id}"
  cidr_block = "${var.subnet_cidr_block_list[0]}"
  availability_zone = "${format("%sa", var.aws_region)}"
}

resource "aws_subnet" "worker_subnet_b" {
  count = "${var.number_of_aws_availability_zones_to_use > 1 ? 1 : 0}"
  vpc_id = "${var.aws_vpc_id}"
  cidr_block = "${var.subnet_cidr_block_list[1]}"
  availability_zone = "${format("%sb", var.aws_region)}"
}

resource "aws_subnet" "worker_subnet_c" {
  count = "${var.number_of_aws_availability_zones_to_use > 2 ? 1 : 0}"
  vpc_id = "${var.aws_vpc_id}"
  cidr_block = "${var.subnet_cidr_block_list[2]}"
  availability_zone = "${format("%sc", var.aws_region)}"
}

resource "aws_route_table_association" "ucp_worker_to_inet_route_a" {
  subnet_id = "${aws_subnet.worker_subnet_a.id}"
  route_table_id = "${var.aws_vpc_route_table_id}"
}

resource "aws_route_table_association" "ucp_worker_to_inet_route_b" {
  count = "${var.number_of_aws_availability_zones_to_use > 1 ? 1 : 0}"
  subnet_id = "${aws_subnet.worker_subnet_b.id}"
  route_table_id = "${var.aws_vpc_route_table_id}"
}

resource "aws_route_table_association" "ucp_worker_to_inet_route_c" {
  count = "${var.number_of_aws_availability_zones_to_use > 2 ? 1 : 0}"
  subnet_id = "${aws_subnet.worker_subnet_c.id}"
  route_table_id = "${var.aws_vpc_route_table_id}"
}

resource "aws_instance" "ucp_worker_a" {
  depends_on = [
    "aws_subnet.worker_subnet_a"
  ]
  count = "${var.number_of_aws_availability_zones_to_use == 0 ? 1 : var.number_of_workers_per_az }"
  associate_public_ip_address = true
  subnet_id = "${aws_subnet.worker_subnet_a.id}"
  ami = "${data.aws_ami.ubuntu.id}"

  instance_type = "${var.aws_ec2_instance_size}"
  key_name = "${var.aws_environment_name}"
  vpc_security_group_ids = [
    "${var.aws_vpc_ssh_access_policy_sg_id}",
    "${var.docker_ucp_security_group_id}"
  ]
  tags = {
    Name = "ucp-worker"
    Environment = "${var.aws_environment_name}"
  }
  root_block_device = {
    volume_size = 8
    delete_on_termination = true
  }
}
resource "null_resource" "provision_ucp_worker_a" {
  triggers {
    ucp_worker_changes = "${join(",", aws_instance.ucp_worker_a.*.id)}"
  }
  count = "${var.number_of_aws_availability_zones_to_use > 1 ? var.number_of_workers_per_az : 0}"
  provisioner "local-exec" {
    command = <<EOF
ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook \
  --private-key ${var.aws_ec2_private_key_location} \
  -i ${element(aws_instance.ucp_worker_a.*.public_ip,count.index)}, \
  -e docker_ee_repo_url=${var.docker_ee_repo_url} \
  -e ucp_role=worker \
  -e is_primary_node=false \
  -e docker_ucp_swarm_leader=${var.docker_swarm_leader_ip} \
  docker-ucp-playbook.yml
EOF
  }
}
resource "aws_elb_attachment" "ucp_worker_a" {
  count = "${var.number_of_aws_availability_zones_to_use == 0 ? 1 : var.number_of_workers_per_az }"
  elb = "${var.ucp_manager_elb_id}"
  instance = "${element(aws_instance.ucp_worker_a.*.id, count.index)}"
}

resource "aws_route53_record" "ucp_worker_a" {
  depends_on = [
    "aws_instance.ucp_worker_a"
  ]
  count = "${var.number_of_workers_per_az}"
  zone_id = "${var.aws_route53_zone_id}"
  name = "${format("%d.ucp_worker_a",count.index)}"
  type = "CNAME"
  ttl = 1
  records = [ "${element(aws_instance.ucp_worker_a.*.public_dns, count.index)}" ]
}

resource "aws_instance" "ucp_worker_b" {
  depends_on = [
    "aws_subnet.worker_subnet_b"
  ]
  associate_public_ip_address = true
  subnet_id = "${aws_subnet.worker_subnet_b.id}"
  count = "${var.number_of_aws_availability_zones_to_use > 1 ? var.number_of_workers_per_az : 0}"
  ami = "${data.aws_ami.ubuntu.id}"
  availability_zone = "${format("%sb", var.aws_region)}" 
  instance_type = "${var.aws_ec2_instance_size}"
  key_name = "${var.aws_environment_name}"
  vpc_security_group_ids = [
    "${var.aws_vpc_ssh_access_policy_sg_id}",
    "${var.docker_ucp_security_group_id}"
  ]
  tags = {
    Name = "ucp-worker"
    Environment = "${var.aws_environment_name}"
  }
  root_block_device = {
    volume_size = 8
    delete_on_termination = true
  }
}

resource "aws_elb_attachment" "ucp_worker_b" {
  count = "${var.number_of_aws_availability_zones_to_use > 1 ? var.number_of_workers_per_az : 0}"
  elb = "${var.ucp_manager_elb_id}"
  instance = "${element(aws_instance.ucp_worker_b.*.id, count.index)}"
}

resource "aws_route53_record" "ucp_worker_b" {
  depends_on = [
    "aws_instance.ucp_worker_b"
  ]
  count = "${var.number_of_aws_availability_zones_to_use > 1 ? var.number_of_workers_per_az : 0 }"
  zone_id = "${var.aws_route53_zone_id}"
  name = "${format("%d.ucp_worker_b",count.index)}"
  type = "CNAME"
  ttl = 1
  records = [ "${element(aws_instance.ucp_worker_b.*.public_dns, count.index)}" ]
}

resource "null_resource" "provision_ucp_worker_b" {
  triggers {
    ucp_worker_changes = "${join(",", aws_instance.ucp_worker_b.*.id)}"
  }
  count = "${var.number_of_aws_availability_zones_to_use > 1 ? var.number_of_workers_per_az : 0}"
  provisioner "local-exec" {
    command = <<EOF
ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook \
  -u ubuntu \
  --private-key ${var.aws_ec2_private_key_location} \
  -i ${element(aws_instance.ucp_worker_b.*.public_ip,count.index)}, \
  -e docker_ee_repo_url=${var.docker_ee_repo_url} \
  -e ucp_role=worker \
  -e is_primary_node=false \
  -e docker_ucp_swarm_leader=${var.docker_swarm_leader_ip} \
  docker-ucp-playbook.yml
EOF
  }
}

resource "aws_instance" "ucp_worker_c" {
  depends_on = [
    "aws_subnet.worker_subnet_c"
  ]
  associate_public_ip_address = true
  subnet_id = "${aws_subnet.worker_subnet_c.id}"
  count = "${var.number_of_aws_availability_zones_to_use > 2 ? var.number_of_workers_per_az : 0}"
  ami = "${data.aws_ami.ubuntu.id}"
  availability_zone = "${format("%sc", var.aws_region)}" 
  instance_type = "${var.aws_ec2_instance_size}"
  key_name = "${var.aws_environment_name}"
  vpc_security_group_ids = [
    "${var.aws_vpc_ssh_access_policy_sg_id}",
    "${var.docker_ucp_security_group_id}"
  ]
  tags = {
    Name = "ucp-worker"
    Environment = "${var.aws_environment_name}"
  }
  root_block_device = {
    volume_size = 8
    delete_on_termination = true
  }
}

resource "aws_elb_attachment" "ucp_worker_c" {
  count = "${var.number_of_aws_availability_zones_to_use > 2 ? var.number_of_workers_per_az : 0}"
  elb = "${var.ucp_manager_elb_id}"
  instance = "${element(aws_instance.ucp_worker_c.*.id, count.index)}"
}

resource "null_resource" "provision_ucp_worker_c" {
  triggers {
    ucp_worker_changes = "${join(",", aws_instance.ucp_worker_c.*.id)}"
  }
  count = "${var.number_of_aws_availability_zones_to_use > 2 ? var.number_of_workers_per_az : 0}"
  provisioner "local-exec" {
    command = <<EOF
ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook \
  -u ubuntu \
  --private-key ${var.aws_ec2_private_key_location} \
  -i ${element(aws_instance.ucp_worker_c.*.public_ip,count.index)}, \
  -e docker_ee_repo_url=${var.docker_ee_repo_url} \
  -e ucp_role=worker \
  -e is_primary_node=false \
  -e docker_ucp_swarm_leader=${var.docker_swarm_leader_ip} \
  docker-ucp-playbook.yml
EOF
  }
}

resource "aws_route53_record" "ucp_worker_c" {
  depends_on = [
    "aws_instance.ucp_worker_c"
  ]
  count = "${var.number_of_aws_availability_zones_to_use > 2 ? var.number_of_workers_per_az  : 0}"
  zone_id = "${var.aws_route53_zone_id}"
  name = "${format("%d.ucp_worker_c",count.index)}"
  type = "CNAME"
  ttl = 1
  records = [ "${element(aws_instance.ucp_worker_c.*.public_dns, count.index)}" ]
}
