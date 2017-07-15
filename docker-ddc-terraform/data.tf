data "terraform_remote_state" "this_environment" {
  backend = "s3"
  config {
    bucket = "${var.aws_s3_infrastructure_bucket}"
    key = "${join(".",list("tfstate",var.environment_name))}"
    region = "${var.aws_region}"
  }
}
