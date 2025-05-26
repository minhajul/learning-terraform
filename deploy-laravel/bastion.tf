resource "aws_instance" "bastion" {
  ami                         = "ami-0b1e534a4ff9019e0" # Ubuntu 22.04 LTS
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  key_name                    = var.key_pair_name
  associate_public_ip_address = true

  tags = {
    Name = "bastion-host" # Replace name
  }
}