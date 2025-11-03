output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.web_server.id
}

output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_eip.tailscale.public_ip
}

output "private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.web_server.private_ip
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.app_sg.id
}

output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh -i ~/.ssh/web_key ubuntu@${aws_eip.tailscale.public_ip}"
}

output "tailscale_status_command" {
  description = "Command to check Tailscale status on the instance"
  value       = "ssh -i ~/.ssh/web_key ubuntu@${aws_eip.tailscale.public_ip} 'sudo tailscale status'"
}