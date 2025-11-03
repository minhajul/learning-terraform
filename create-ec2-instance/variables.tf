variable "aws_region" {
  description = "AWS region"
  default     = "ap-southeast-1"
  type        = string
}

variable "vpc_tag_name" {
  description = "Tag name of the aws vpc"
  type        = string
  default     = "your-vpc"
}

variable "aws_internet_gateway_tag_name" {
  description = "Tag name of the aws ig"
  type        = string
  default     = "your-igw"
}

variable "aws_nat_gateway_name" {
  description = "Nat gateway name"
  type        = string
  default     = "your-igw"
}

variable "aws_security_group_name" {
  description = "Name of aws sg"
  type        = string
  default     = "your-sg"
}


variable "key_pair_name" {
  description = "Name of the existing EC2 key pair"
  type        = string
}
