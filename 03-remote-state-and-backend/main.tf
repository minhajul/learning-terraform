provider "aws" {
    region = "ap-southeast-1" # your region
}

resource "aws_vpc" "main_vpc" {
    cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main_subnet" {
    vpc_id     = aws_vpc.main_vpc.id
    cidr_block = "10.0.1.0/24"
}

terraform {
    backend "remote" {
        organization = "your-organisation" # Your organisation

        workspaces {
            name = "your-workspace"  # Your workspace
        }
    }
}