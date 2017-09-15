terraform {
  // We would usually use something like S3 for remote state. However,
  // Terraform Enterprise is a fully-managed solution that obviates this.
  // While Terraform Enterprise can leverage S3-backed remote states,
  // they would need to be made internet-readable, which is a
  // large security risk.
  //
  // Therefore, we're going to change our remote state backend to Atlas
  // (Terraform Enterprise).
  backend "atlas" {
    name = "carlosonunez/simple_tier_webapp"
  }
}
