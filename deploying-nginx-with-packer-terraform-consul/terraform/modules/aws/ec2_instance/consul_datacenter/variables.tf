variable "ami_id" {
  description = "The AMI to provision this instance with."
}

variable "aws_access_key" {
  description = "AWS access key. Used to populate Consul systemd service."
}

variable "aws_secret_key" {
  description = "AWS secret key. Used to populate Consul systemd service."
}

variable "instance_type" {
  description = "The instance type to apply onto this EC2 instance."
}

variable "key_name" {
  description = "The EC2 public key to use for logging into this instance."
}

variable "vpc_id" {
  description = "The VPC to provision this instance into."
}

variable "subnet_id" {
  description = "The ID of the subnet to provision this instance into."
}

variable "aws_environment" {
  description = "The environment into which this instance will be categorized."
}

variable "disk_size" {
  description = "The size of the disk to give this instance."
  default     = 8
}

variable "count" {
  description = "Number of instances to provision."
}

variable "private_key_location" {
  description = "The location to our private key on disk. This is used to connect to our provisioned instances and run provisioning steps."
}
