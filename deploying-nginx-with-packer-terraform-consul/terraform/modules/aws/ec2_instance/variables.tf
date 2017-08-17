output "instance_id" {
  value = "${aws_instance.instance.id}"
  availability_zone = "${aws_instance.instance.availability_zone}"
  public_dns = "${aws_instance.instance.public_dns}"
}
