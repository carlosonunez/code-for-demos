variable "web_server_ami_id" {
  description = "The AMI to use for our web servers."
}

variable "web_server_instance_type" {
  description = "The instance size to use for our web servers."
  default     = "t2.micro"
}
