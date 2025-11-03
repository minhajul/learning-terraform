## Terraform Remote State and Remote Backends

This repository contains Terraform configuration files to create a basic AWS VPC and subnet.  
It also uses **Terraform Cloud** as the remote backend to store and manage the Terraform state file securely.

---

### Getting Started

Log in to Terraform Cloud and generate a Terraform Cloud Token. Then copy the token to use in the next step.

```bash 
terraform login
```

Run the above command and paste the API token when prompted.

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