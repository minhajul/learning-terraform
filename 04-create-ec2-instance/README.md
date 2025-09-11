## Create Just a EC2 Instance in AWS

This Terraform configuration provisions a simple ec2 to host your application. It includes:

- A custom VPC with public subnets across multiple AZs
- App host in a public subnet for secure SSH access
- Internet Gateway, NAT Gateway, route tables, and security groups

### Prerequisites

Set up your AWS credentials by configuring the AWS CLI:

```bash
aws configure
```

### Getting Started

If you don't have an SSH key pair, generate one using the following command:

```bash
ssh-keygen -t rsa -b 2048 -f ~/.ssh/web_key -N ""
```

This will create two files: `web_key (private key)` and `web_key.pub (public key)` in your `.ssh` directory.


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