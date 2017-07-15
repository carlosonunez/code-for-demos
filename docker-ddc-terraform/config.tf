terraform {
  backend "s3" {
    # Terraform doesn't support interpolations here.
    # To work around this, we use the --backend-config argument a few times
    # in ./infra.
  }
}
