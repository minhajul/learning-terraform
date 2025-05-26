variable "aws_region" {
  description = "AWS region"
  default     = "ap-southeast-1"
}

variable "key_pair_name" {
  description = "Name of the existing EC2 key pair"
  type        = string
}

variable "allowed_ip" {
  description = "IP address allowed to access bastion host"
  type        = string
}