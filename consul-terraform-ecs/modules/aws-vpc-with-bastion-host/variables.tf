variable "aws_vpc_cidr_block" {
  description = "The CIDR block to use for your VPC."
}

variable "aws_vpc_dns_domain" {
  description = "The DNS domain to which hosts within this VPC will be bound."
}

variable "aws_environment_name" {
  description = "The name of the environment to which hosts in this AWS account are bound."
}

variable "terraform_deployer_ip" {
  description = "The IP address of the machine that's deploying this infrastructure. Needed so that Terraform can continue to provision machines within the VPC."
}

variable "aws_route53_zone_id" {
  description = "The Route53 zone hosting this gateway's CNAME record."
}

variable "management_subnet_cidr_block" {
  description = "The CIDR block in which management instances will live."
}

variable "aws_ec2_private_key_location" {
  description = "Location to the EC2 private key used for this environment."
}
