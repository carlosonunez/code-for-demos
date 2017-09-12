variable "aws_s3_tfstate_bucket_name" {
  description = "The name of the S3 bucket containing tfstates."
}

variable "environment_name" {
  description = "The name of the environment being targetted."
}

variable "aws_region" {
  description = "The AWS region in which this infrastructure will be hosted."
}

variable "aws_access_key" {
  description = "The access key to use for authenticating with AWS."
}

variable "aws_secret_key" {
  description = "The secret key to ues for authenticating with AWS."
}

variable "aws_public_instances_subnet_cidr_block" {
  description = "The CIDR block to give to the subnet holding instances with inbound/outbound internet access."
}

variable "number_of_web_servers" {
  description = "The number of web servers to provision. In a more real-world scenario, you might consider having these instances spread out across availability zones for redundancy."
  default     = 3
}

variable "environment_public_key" {
  description = "The public key to use for accessing instances created within this environment."
}

variable "private_key_location" {
  description = "The location to the private key used to connect to the instance."
}
