output "ucp_manager_elb_id" {
  value = "${element(aws_elb.*.id, 1)}"
}

output "ucp_manager_elb_dns_name" {
  value = "${element(aws_elb.*.dns_name, 1)}"
}
