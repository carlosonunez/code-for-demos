resource "aws_key_pair" "ec2_key" {
  key_name = "${var.aws_environment_name}"
  public_key = "${var.aws_ec2_public_key}"
}

output "ec2_key" {
  value = "${aws_key_pair.ec2_key.key_name}"
}
