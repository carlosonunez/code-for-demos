variable "aws_s3_tfstate_bucket_name" {
  description = "The name of the S3 bucket containing tfstates."
}

variable "environment_name" {
  description = "The name of the environment being targetted."
}

variable "aws_region" {
  description = "The AWS region in which this infrastructure will be hosted."
}

variable "ami_id" {
  description = "The AMI to provision this instance with."
}

variable "instance_type" {
  description = "The size of the EC2 instance to provision."
}

variable "aws_public_instances_subnet_cidr_block" {
  description = "The CIDR block to give to the subnet holding instances with inbound/outbound internet access."
}
