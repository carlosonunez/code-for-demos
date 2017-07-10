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
  # required to force this to be an int.
  description = "The number of availability zones to deploy UCP managers onto."
  default = 1
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

variable "management_subnet_cidr_block" {
  description = "The CIDR block to use for the management subnet."
}

variable "docker_ucp_manager_subnet_cidr_block_list" {
  type = "list"
  description = "A list of CIDR blocks to use for Docker UCP managers (one for each subnet being deployed to)."
}

variable "docker_ucp_worker_subnet_cidr_block_list" {
  type = "list"
  description = "A list of The CIDR blocks to use for Docker UCP workers (one for each subnet being deployed to)."
}
