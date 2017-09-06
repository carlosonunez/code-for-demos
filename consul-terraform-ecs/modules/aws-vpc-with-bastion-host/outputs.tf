output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "bastion_host_sg_id" {
  value = "${aws_security_group.bastion_host.id}"
}

output "default_ssh_sg_id" {
  value = "${aws_security_group.all_instances.id}"
}

output "route_table_id" {
  value = "${aws_route_table.vpc_route_table.id}"
}

output "dns_address" {
  value = "${aws_route53_record.bastion_host.fqdn}"
}
