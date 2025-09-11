## Terraform Provisioners in AWS
Provisioners in Terraform are special blocks that allow you to run scripts or commands on a resource after it is created (or before it is destroyed).

They are most commonly used with `aws_instance` or other compute resources to configure them after launch — for example, installing software, running shell scripts, or notifying external systems.

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

Generate an SSH key pair if you don’t have one already. This key will be used to SSH into the EC2 instance.
```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
```

The public key will be saved in `~/.ssh/id_rsa.pub` by default.

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