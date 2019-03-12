data "http" "ip" {
  # TODO: Replace below call with self-controlled URL
  # Assumes DEV computer has same IP as Terraform execution computer
  url = "http://icanhazip.com"
}

data "aws_availability_zones" "available" {}
