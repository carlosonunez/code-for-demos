variable "aws_vpc_id" {
  description = "The VPC into which this Docker UCP cluster will be deployed."
}

variable "aws_vpc_ssh_access_policy_sg_id" {
  description = "The security group describing the access policy for instances within this VPC."
}

variable "aws_route53_zone_id" {
  description = "The Route 53 zone from which records for this cluster will be hosted."
}

variable "number_of_availability_zones_to_use" {
  description = "The number of AZs to use. The AZs selected for each UCP manager will be in ascending order based on the count provided, e.g. '1' = 'region-a', '2' = ['region-a','region-b'], etc."
}

variable "aws_ec2_instance_size" {
  description = "The instance size to use for *all* UCP managers."
}
