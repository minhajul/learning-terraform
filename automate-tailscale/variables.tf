variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "vpc_tag_name" {
  description = "VPC tag name"
  type        = string
  default     = "tailscale-vpc"
}

variable "aws_internet_gateway_tag_name" {
  description = "Internet gateway tag name"
  type        = string
  default     = "tailscale-igw"
}

variable "aws_nat_gateway_name" {
  description = "NAT gateway name"
  type        = string
  default     = "tailscale-nat"
}

variable "aws_security_group_name" {
  description = "Security group name"
  type        = string
  default     = "tailscale-sg"
}

variable "tailscale_auth_key" {
  description = "Tailscale auth key for device registration"
  type        = string
  sensitive   = true
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key"
  type        = string
  default     = "~/.ssh/web_key.pub"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "root_volume_size" {
  description = "Root volume size in GB"
  type        = number
  default     = 20
}