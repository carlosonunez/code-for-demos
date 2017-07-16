variable "aws_vpc_id" {
  description = "The VPC into which this Docker UCP cluster will be deployed."
}

variable "aws_vpc_ssh_access_policy_sg_id" {
  description = "The security group describing the access policy for instances within this VPC."
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

variable "subnet_cidr_block_list" {
  type = "list"
  description = "A list of CIDR block to use for the subnet created for Docker UCP managers. The subnets chosen for each availability zone are selected based on their positions within the list, i.e. the subnet for ${REGION}a will be the first element of this list."
}

variable "aws_ec2_private_key_location" {
  description = "The private key to provision into our instances."
}

variable "docker_ee_repo_url" {
  description = "The URL to your licensed Docker EE repository. Log into the Docker Store to retrieve this value."
}

variable "aws_vpc_route_table_id" {
  description = "The route table to which the subnet for UCP managers will be associated."
}

variable "docker_swarm_leader_ip" {
  description = "The IP address belonging to the leader of this Swarm. For this stack, this is the IP of the first manager created."
}

variable "number_of_workers_per_az" {
  description = "The number of workers to deploy per availablility zone."
}

variable "docker_ucp_security_group_id" {
  description = "The security group ID for ucp instances."
}

variable "ucp_manager_lb_security_group" {
  description = "The security group ID for our UCP manager cluster. This is needed to give our load balancer inbound access to our cluster without creating another security group."
}

variable "ucp_manager_elb_id" {
  description = "The ID of the manager ELB to attach our workers to. This is done to allow us to access services hosted by the cluster using one DNS address."
}
