variable "aws_s3_tfstate_bucket_name" {
  description = "The name of the S3 bucket containing tfstates."
}

variable "environment_name" {
  description = "The name of the environment being targetted."
}

variable "aws_region" {
  description = "The AWS region in which this infrastructure will be hosted."
}
