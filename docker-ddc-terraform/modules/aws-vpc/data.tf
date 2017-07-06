data "aws_ami" "CoreOS" {
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
