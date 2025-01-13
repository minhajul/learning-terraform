# Learning Terraform with AWS

This repository is created for the purpose of learning and practicing Terraform concepts and how they apply to AWS. It contains various Terraform configurations for provisioning resources and managing infrastructure on AWS.

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [Structure](#structure)
- [Usage](#usage)
- [Notes](#notes)
- [Contributing](#contributing)

## Introduction

Terraform is an open-source infrastructure as code (IaC) tool that allows you to define, provision, and manage cloud resources using a declarative configuration language. In this repository, we explore how to use Terraform to interact with AWS, including setting up networks, EC2 instances, databases, S3 buckets, and more.

## Prerequisites

Before you start using Terraform with AWS, ensure you have the following installed and configured:

- [Terraform](https://www.terraform.io/downloads.html) - Version 1.x or newer
- [AWS CLI](https://aws.amazon.com/cli/) - Version 2.x
- [An AWS Account](https://aws.amazon.com/)

Additionally, set up your AWS credentials by configuring the AWS CLI:

```bash
aws configure
```

## Getting Started

Clone this repository:

```bash
git clone https://github.com/minhajul/learning-terraform.git
cd learning-terraform
```

Initialize Terraform to download the necessary provider plugins:

```bash
terraform init
```

Review and modify configuration files as necessary.

Apply the Terraform configuration to provision the resources on AWS:

```bash
terraform apply
```

Terraform will prompt you to confirm the plan. Type `yes` to proceed.

Once done, destroy the resources if you no longer need them:

```bash
terraform destroy
```

## Structure

This repository is organized into different directories and files for various AWS resources:

- `vpc/` – Contains Terraform configurations for setting up a VPC.
- `ec2/` – Includes configurations to create EC2 instances.
- `s3/` – Contains configurations to provision S3 buckets.
- `rds/` – Sets up an RDS database instance.
- `outputs.tf` – Terraform outputs after resources are created.
- `variables.tf` – Define input variables for the Terraform configurations.
- `main.tf` – The primary configuration file for the infrastructure.

## Usage

1. **Creating Resources:** To create resources, simply use the `terraform apply` command from within any of the subdirectories. Modify the variables and configurations to suit your needs.

2. **Output:** Once the configuration is applied, Terraform will output the details of the created resources, such as EC2 instance public IP, S3 bucket URL, etc.

3. **Variables and Customization:** Customize `variables.tf` and the main configuration files (`main.tf`) to define your AWS resources, such as security groups, instances, VPCs, etc.

## Notes

- Always be careful when applying Terraform configurations on your AWS account. Some resources can incur costs, such as EC2 instances and RDS databases.
- Use the `terraform destroy` command to remove resources after experimentation or when they are no longer needed to avoid unnecessary charges.

## Contributing

Feel free to fork this repository, make changes, and submit pull requests. This project is primarily for educational purposes, so if you encounter any issues, please open an issue, and we will work on resolving it.
```