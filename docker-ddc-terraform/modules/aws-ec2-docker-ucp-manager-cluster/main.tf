data "aws_ami" "coreos" {
  most_recent = true
  filter {
    name = "owner-id"
    values = [ "595879546273" ]
  }
  filter {
    name = "virtualization-type"
    values = [ "hvm" ]
  }
  filter {
    name = "name"
    values = [ "CoreOS-stable*" ]
  }
}

resource "aws_security_group" "ucp_manager" {
  name = "ucp_manager-sg"
  description = "Security group for UCP managers. Managed by Terraform."
  vpc_id = "${var.aws_vpc_id}"
  ingress {
    self = true
    from_port = 0
    to_port = 0
    protocol = -1
  }
}

resource "aws_security_group" "ucp_manager_lb" {
  depends_on = [ "aws_security_group.ucp_manager" ]
  name = "ucp-manager-lb-sg"
  description = "Security group for load balancer in front of UCP managers. Enables external access to UCP. Managed by Terraform."
  vpc_id = "${var.aws_vpc_id}"
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    security_groups = [ "${aws_security_group.ucp_manager.id}" ]
}

