terraform {
  backend "s3" {
    bucket = "${var.aws_s3_infrastructure_bucket}"
    key = "${join("//",list("tfstate",var.environment_name)}"
    region = "${var.aws_region}"
  }
}
