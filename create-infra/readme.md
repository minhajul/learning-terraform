## Scalable Infrastructure in AWS

This Terraform configuration provisions a scalable and secure AWS infrastructure to host your application. It includes:

- A custom VPC with public and private subnets across multiple AZs
- Bastion host in a public subnet for secure SSH access
- Private EC2 instances launched via a Launch Template and managed by an Auto Scaling Group
- Application Load Balancer with target group and listener
- Internet Gateway, NAT Gateway, route tables, and security groups

Designed for high availability and scalability, this setup serves as a robust foundation for deploying application in production.

### Prerequisites

Set up your AWS credentials by configuring the AWS CLI:

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