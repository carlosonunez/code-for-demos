variable "aws_vpc_id" {
  description = "The VPC into which this Docker UCP cluster will be deployed."
}

variable "aws_vpc_ssh_access_policy_sg_id" {
  description = "The security group describing the access policy for instances within this VPC."
}

variable "aws_vpc_subnet_id" {
  description = "The VPC subnet to provision these instances into."
}

variable "aws_route53_zone_id" {
  description = "The Route 53 zone from which records for this cluster will be hosted."
}

variable "number_of_aws_availability_zones_to_use" {
  # this default is required to force this to use the 'int' datatype.
  description = "The number of AZs to use. The AZs selected for each UCP manager will be in ascending order based on the count provided, e.g. '1' = 'region-a', '2' = ['region-a','region-b'], etc. As such, at least one manager will always be deployed onto AZ 'a'."
  default = 0
}

variable "aws_ec2_instance_size" {
  description = "The instance size to use for *all* UCP managers."
}

variable "aws_region" {
  description = "The region to deploy these instances into."
}

variable "aws_environment_name" {
  description = "The name of the environment into which this cluster will be deployed."
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
