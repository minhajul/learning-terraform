## Create VPC in AWS

Terraform script to create a VPC with public and private subnet.

### Prerequisites

Before you start using Terraform with AWS, ensure you have the following installed and configured:

- [Terraform](https://www.terraform.io/downloads.html) - Version 1.x or newer
- [AWS CLI](https://aws.amazon.com/cli/) - Version 2.x
- [An AWS Account](https://aws.amazon.com/)

Additionally, set up your AWS credentials by configuring the AWS CLI:

```bash
aws configure
```

### Getting Started

Adjust ```main.tf``` file according to your need and run below command to initialize Terraform to download the necessary provider plugins:

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

### Notes

- Always be careful when applying Terraform configurations on your AWS account. Some resources can incur costs, such as EC2 instances and RDS databases.
- Use the `terraform destroy` command to remove resources after experimentation or when they are no longer needed to avoid unnecessary charges.