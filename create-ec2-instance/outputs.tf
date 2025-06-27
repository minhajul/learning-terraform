output "bastion_public_ip" {
  value = aws_instance.app.public_ip
}