variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "Private IPv4 CIDR range for proxy server VPC (size must be at least /20)"
}

variable "ssh_key_name" {
  type        = "string"
  description = "Name of pre-existing SSH key to be used for connecting to proxy server"
}

variable "proxy_server_name" {
  default     = "Proxy Server"
  description = "Name tag to associate with proxy server"
}

variable "instance_type" {
  default     = "t3.micro"
  description = "Instance type to use for proxy server"
}

variable "domain" {
  type        = "string"
  description = "Name of a pre-existing Route 53 domain to use for the proxy server"
}

variable "subdomain" {
  type        = "string"
  description = "DNS subdomain to use for the proxy server"
}

variable "vpc_name" {
  default     = "proxy-vpc"
  description = "Name tag to use for proxy server VPC"
}

variable "region" {
  type        = "string"
  description = "AWS region that resources should launch into"
}
