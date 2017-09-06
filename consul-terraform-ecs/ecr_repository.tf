resource "aws_ecr_repository" "repo" {
  name = "${format("ecr-repo-%s",var.environment_name)}"
}
