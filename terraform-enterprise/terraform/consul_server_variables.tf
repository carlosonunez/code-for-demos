variable "number_of_consul_servers" {
  description = "The number of Consul servers to deploy into your datacenter."
  default     = 5
}

variable "consul_server_instance_type" {
  description = "The instance type to use for your Consul servers."
  default     = "t2.micro"
}
