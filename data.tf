data "http" "ip" {
  # TODO: Replace below call with self-controlled URL
  # Assumes DEV computer has same IP as Terraform execution computer
  url = "http://icanhazip.com"
}

data "aws_availability_zones" "available" {}

data "aws_ami" "proxy" {
  most_recent = true
  owners      = ["410186602215"]

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "name"
    values = ["CentOS Linux 7 x86_64 HVM EBS*"]
  }
}

data "aws_route53_zone" "domain" {
  name = "${var.domain}"
}
