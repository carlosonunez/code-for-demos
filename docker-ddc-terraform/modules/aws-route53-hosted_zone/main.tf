resource "aws_route53_zone" "hosted_zone" {
  name = "${join(".", list(var.aws_environment_name,var.aws_route53_zone_name))}"
  comment = "${var.aws_route53_zone_comment}"
  tags = {
    Name = "${var.aws_route53_zone_name}"
    Environment = "${var.aws_environment_name}"
  }
}
