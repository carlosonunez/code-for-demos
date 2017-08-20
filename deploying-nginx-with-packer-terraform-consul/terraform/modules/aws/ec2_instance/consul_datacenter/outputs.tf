output "instance_id" {
  value = "${aws_instance.instance.*.id}"
}

output "availability_zone" {
  value = "${aws_instance.instance.*.availability_zone}"
}

output "public_dns_address" {
  value = "${aws_instance.instance.*.public_dns}"
}

output "public_ip_address" {
  value = "${aws_instance.instance.*.public_ip}"
}
