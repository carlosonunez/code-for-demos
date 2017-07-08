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

variable "load_balancer_number_of_checks_until_healthy" {
  description = "The number of checks before the instance is declared healthy."
  default = 3
}

variable "load_balancer_number_of_checks_until_not_healthy" {
  description = "The number of checks before the instance is declared unhealthy."
  default = 3
}

variable "load_balancer_target" {
  description = "The load balancer target path. See here for more details on the formatting: https://www.terraform.io/docs/providers/aws/r/elb.html"
  default = "HTTPS:443/_ping"
}

variable "load_balancer_origin_port" {
  description = "The port on the instances backed by this load balancer to direct traffic to."
  default = 443
}

variable "load_balancer_origin_protocol" {
  description = "The protocol being served by these backed instances."
  default = "https"
}

variable "load_balancer_listening_port" {
  description = "The port that this load balancer will listen on."
  default = 443
}

variable "load_balancer_listening_protocol" {
  description = "The protocol that this load balancer will listen on."
  default = "http"
}

variable "load_balancer_health_check_interval_in_seconds" {
  description = "The amount of time (in seconds) to wait between health checks."
  default = 15
}

variable "load_balancer_health_check_timeout_in_seconds" {
  description = "The amount of time (in seconds) to wait until the health check times out."
  default = 5
}
