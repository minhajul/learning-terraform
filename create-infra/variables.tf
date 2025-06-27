variable "aws_region" {
  description = "AWS region"
  default     = "ap-southeast-1"
}

variable "aws_vpc_tag_name" {
  description = "Tag name of the aws vpc"
  type        = string
  default     = "terraform-vpc"
}

variable "aws_internet_gateway_tag_name" {
  description = "Tag name of the aws ig"
  type        = string
  default     = "terraform-igw"
}

variable "key_pair_name" {
  description = "Name of the existing EC2 key pair"
  type        = string
}
