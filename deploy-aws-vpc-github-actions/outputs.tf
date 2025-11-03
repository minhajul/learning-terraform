output "public_ip" {
  value = aws_instance.ec2.public_ip
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "subnet_id" {
  value = module.vpc.public_subnets[0]
}

output "security_group_id" {
  value = aws_security_group.your_sg.id
}