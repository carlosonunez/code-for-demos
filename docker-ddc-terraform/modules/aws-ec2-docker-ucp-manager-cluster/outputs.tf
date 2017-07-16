output "ucp_manager_elb_id" {
  value = "${aws_elb.ucp_manager_elb_dual_az.id}"
}

output "dns_address" {
  value = "${coalesce(aws_route53_record.ucp_manager_elb_single_az.fqdn,
                  aws_route53_record.ucp_manager_elb_dual_az.fqdn,
                  aws_route53_record.ucp_manager_elb_tri_az.fqdn)}"
}

output "docker_ucp_manager_lb_security_group_id" {
  value = "${aws_security_group.ucp_manager_lb.id}"
}

output "docker_ucp_manager_cluster_leader_ip" {
  value = "${aws_instance.ucp_manager_a.private_ip}"
}

output "docker_ucp_cluster_security_group_id" {
  value = "${aws_security_group.ucp_manager.id}"
}
