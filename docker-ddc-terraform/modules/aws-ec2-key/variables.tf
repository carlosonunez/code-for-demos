variable "aws_environment_name" {
  description = "The name of the environment into which this infrastructure is being deployed."
}

variable "aws_ec2_public_key" {
  description = "The public key to be used for this environment's key pair."
}
