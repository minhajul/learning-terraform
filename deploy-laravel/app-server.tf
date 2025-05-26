resource "aws_instance" "app" {
  ami                    = "ami-0b1e534a4ff9019e0" # Ubuntu 22.04 LTS
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.app.id]
  key_name               = var.key_pair_name

  user_data = file("${path.module}/user-data-app.sh")

  tags = {
    Name = "laravel-app-server" # Replace name
  }
}