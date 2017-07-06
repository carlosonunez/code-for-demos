variable "aws_vpc_cidr_block" {
  description = "The VPC CIDR block to use for this environment."
}

variable "dns_zone_to_use" {
  description = "The public DNS zone into which deployed hosts will reside."
}

variable "environment_name" {
  description = "The name of the environment being deployed."
}

variable "environment_rsa_public_key" {
  description = "The RSA public key to use for this environment. Ensure that its corresponding private key is stored somewhere where you won't lose it!"
}

variable "ucp_az_count" {
  description = "The number of availability zones to deploy UCP managers onto."
}

variable "ucp_manager_instance_size" {
  description = "The size to use for our UCP managers."
}

variable "terraform_deployer_ip" {
  description = "The *public* IP address for the machine that is running this Terraform configuration."
}

variable "aws_region" {
  description = "The region to deploy to."
}
