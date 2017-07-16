output "bastion_host_dns_address" {
  value = "${module.vpc_with_bastion_host.dns_address}"
}

output "ucp_dns_address" {
  value = "${module.ucp_manager-cluster.dns_address}"
}
