## Automate Tailscale with Terraform

This Terraform project provisions an AWS EC2 instance configured as a Tailscale exit node, along with all necessary networking infrastructure (VPC, subnets, security groups, etc.).

### 🚀 Getting Started

#### Step 1: Generate SSH Key Pair

If you don't already have an SSH key pair:

```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/web_key
```

This creates:
- `~/.ssh/web_key` (private key)
- `~/.ssh/web_key.pub` (public key)

#### Step 2: Get Tailscale Auth Key

1. Go to [Tailscale Admin Console](https://login.tailscale.com/admin/settings/keys)
2. Click **Generate auth key**
3. Configure the key:
    - ✅ **Reusable** (if you plan to recreate the instance)
    - ✅ **Ephemeral** (optional - removes device when disconnected)
    - Set expiration as needed
4. Copy the generated key (starts with `tskey-auth-`)

#### Step 3: Initialize Terraform

```bash
terraform init
```

#### Step 4: Review the Plan

```bash
terraform plan
```

Review the resources that will be created.

#### Step 5: Apply the Configuration

```bash
terraform apply
```

Type `yes` when prompted to confirm.

#### Step 6: Enable Exit Node in Tailscale

1. Go to [Tailscale Admin Console](https://login.tailscale.com/admin/machines)
2. Find your new device (named after the instance)
3. Click the **⋮** menu next to the device
4. Select **Edit route settings**
5. Enable **Use as exit node**

### Connecting to Your Instance

#### Via SSH

```bash
ssh -i ~/.ssh/web_key ubuntu@<public_ip>
```

#### Check Tailscale Status

```bash
ssh -i ~/.ssh/web_key ubuntu@<public_ip> 'sudo tailscale status'
```

### 🌐 Using the Exit Node

On your Tailscale client devices:

### macOS/Linux/Windows
```bash
tailscale up --exit-node=<device-name>
```

### Cleanup

To destroy all resources:

```bash
terraform destroy
```

Type `yes` when prompted. This will:
1. Terminate the EC2 instance
2. Delete all networking components
3. Release the Elastic IP
4. Remove all created resources

**Note:** Your Tailscale device will remain in the admin console but will show as offline.

### Contributing
Feel free to fork this repository, make changes, and submit pull requests. This project is primarily for educational purposes, so if you encounter any issues, please open an issue, and we will work on resolving it.

### Made with ❤️ by [[minhajul](https://github.com/minhajul)]