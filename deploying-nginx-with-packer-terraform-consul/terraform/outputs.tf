output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "ec2_key" {
  value = "${aws_key_pair.ec2_key_for_environment.key_name}"
}

output "consul_datacenter_ip" {
  value = "${module.consul_datacenter.public_ip}"
}

output "web_server_ip" {
  value = "${module.web_server.public_ip}"
}
