### Automating AWS VPC Deployment with EC2 using GitHub Actions and Terraform Cloud

We will deploy a Virtual Private Cloud (VPC) with a public subnet, an Internet Gateway (IGW), and an EC2
instance. We will use SSH public key to access the EC2 instance and securely manage GitHub Secrets, and the
Terraform state file will be stored in Terraform Cloud to ensure consistency and security across deployments.

### Objectives

- Automate the deployment of an AWS VPC with a public subnet using Terraform and GitHub Actions.
- Securely manage and store an SSH public key using GitHub Secrets.
- Deploy an EC2 instance within the public subnet.
- Store and manage the Terraform state file in Terraform Cloud.
- Output key information such as the EC2 instance’s public IP, VPC ID, Subnet ID, and Security Group ID.

### Step 1: Terraform Cloud Setup

Login to your terraform cloud account and get the cloud token.

### Step 2: Setting Up GitHub Actions

Generate SSH Keys (if you haven't already):

```bash
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

This generates a private key (`id_rsa`) and a public key (`id_rsa.pub`) in the `~/.ssh/` directory.

**Store Secrets:**

Go to Settings > Secrets and variables > Actions > New repository secret.

**Add the following secrets:**
`AWS_ACCESS_KEY_ID:` Your AWS access key ID.
`AWS_SECRET_ACCESS_KEY:` Your AWS secret access key.
`SSH_PRIVATE_KEY:` Paste the contents of your id_rsa file in` ~/.ssh` directory.
`SSH_PUBLIC_KEY:` Paste the contents of your id_rsa.pub in `~/.ssh` directory.
`TF_CLOUD_TOKEN:` Add the Terraform Cloud API token as a secret.

Also create `.github/worflows/deploy.yml` file with below content:

```bash
name: Terraform AWS Deployment

on:
  push:
    branches:
      - main
jobs:
  terraform:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup SSH Key
        uses: webfactory/ssh-agent@v0.9.0
        with:
          ssh-private-key: ${{ secrets.SSH_PRIVATE_KEY }}

      - name: Install Terraform
        uses: hashicorp/setup-terraform@v3

      - name: Configure Terraform Credentials
        run: |
          mkdir -p ~/.terraform.d
          echo '{"credentials":{"app.terraform.io":{"token":"${{ secrets.TF_CLOUD_TOKEN }}"}}}' > ~/.terraform.d/credentials.tfrc.json

      - name: Terraform Init
        run: terraform init
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}

      - name: Terraform Plan
        run: terraform plan -out=tfplan -var "ssh_public_key=${{ secrets.SSH_PUBLIC_KEY }}"
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}

      - name: Save Terraform Plan
        uses: actions/upload-artifact@v4
        with:
          name: tfplan
          path: tfplan

      - name: Download Terraform Plan
        uses: actions/download-artifact@v4
        with:
          name: tfplan
          path: .

      - name: Terraform Apply
        run: terraform apply -auto-approve tfplan
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
```

### Step 3: Validate and Apply the Configuration

Push your changes to GitHub and monitor in the action tab from your GitHub profile:

```bash
git add .
git commit -m "Add Terraform configuration and GitHub Actions workflow"
git push origin main
```

### Step 4: Verify the Deployment

Once the deployment is complete, you can verify the infrastructure by logging into your AWS Management Console. Navigate
to the VPC and EC2 dashboards to check if the resources have been created.

You can also SSH into your EC2 instance using the private key:

```bash
ssh -i ~/.ssh/id_rsa ubuntu@<ec2-public-ip>
```

### Conclusion

We have successfully automated the deployment of an AWS VPC, public subnet, and EC2 instance using Terraform and GitHub
Actions. This process ensures a consistent, repeatable, and secure way to manage your infrastructure deployments.