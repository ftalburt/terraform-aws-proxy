module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 1.0"

  name = "${var.vpc_name}"
  cidr = "${var.vpc_cidr}"

  azs            = ["${data.aws_availability_zones.available.names[0]}"]
  public_subnets = ["${cidrsubnet(var.vpc_cidr, 8, 2)}"]
}

resource "aws_security_group" "sg1" {
  name        = "${var.proxy_server_name} SG"
  description = "${var.proxy_server_name} SG"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.ip.body)}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_route53_zone" "domain" {
  name = "${var.domain}"
}

resource "aws_route53_record" "proxy" {
  zone_id = "${data.aws_route53_zone.domain.zone_id}"
  name    = "${var.subdomain}.${data.aws_route53_zone.domain.name}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.proxy.public_ip}"]
}

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

resource "aws_instance" "proxy" {
  ami                    = "${data.aws_ami.proxy.id}"
  instance_type          = "${var.instance_type}"
  vpc_security_group_ids = ["${aws_security_group.sg1.id}"]
  subnet_id              = "${module.vpc.public_subnets[0]}"
  key_name               = "${var.ssh_key_name}"

  tags {
    Name = "${var.proxy_server_name}"
  }
}
