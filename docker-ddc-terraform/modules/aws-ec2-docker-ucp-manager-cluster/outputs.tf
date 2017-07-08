output "ucp_manager_elb_id" {
  value = "${list(aws_elb.ucp_manager_elb_single_az.id,
                  aws_elb.ucp_manager_elb_dual_az.id,
                  aws_elb.ucp_manager_elb_tri_az.id)}"
}

output "ucp_manager_elb_dns_name" {
  value = "${list(aws_elb.ucp_manager_elb_single_az.dns_name,
                  aws_elb.ucp_manager_elb_dual_az.dns_name,
                  aws_elb.ucp_manager_elb_tri_az.dns_name)}"
}
