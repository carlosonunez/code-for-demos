output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "bastion_host_sg_id" {
  value = "${aws_security_group.bastion_host.id}"
}

output "default_ssh_sg_id" {
  value = "${aws_security_group.all_instances.id}"
}
