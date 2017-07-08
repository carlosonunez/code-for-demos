output "ucp_manager_lb_id" {
  count = "${var.number_of_aws_availability_zones_to_use <= 1 ? 1 : 0}"
  value = "${aws_elb.ucp_manager_elb_single_az.id}"
}
output "ucp_manager_lb_dns_name" {
  count = "${var.number_of_aws_availability_zones_to_use <= 1 ? 1 : 0}"
  value = "${aws_elb.ucp_manager_elb_single_az.dns_name}"
}
output "ucp_manager_lb_id" {
  count = "${var.number_of_aws_availability_zones_to_use == 2 ? 1 : 0}"
  value = "${aws_elb.ucp_manager_elb_dual_az.id}"
}

output "ucp_manager_lb_dns_name" {
  count = "${var.number_of_aws_availability_zones_to_use == 2 ? 1 : 0}"
  value = "${aws_elb.ucp_manager_elb_dual_az.dns_name}"
}

output "ucp_manager_lb_id" {
  count = "${var.number_of_aws_availability_zones_to_use == 3 ? 1 : 0}"
  value = "${aws_elb.ucp_manager_elb_tri_az.id}"
}
output "ucp_manager_lb_dns_name" {
  count = "${var.number_of_aws_availability_zones_to_use == 3 ? 1 : 0}"
  value = "${aws_elb.ucp_manager_elb_tri_az.dns_name}"
}
