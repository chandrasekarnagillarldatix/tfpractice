resource "aws_instance" "app_server" {

  instance_type = "t2.micro"
  ami = var.ami_id
  tags = {
    Name = var.instance_name
  }
}

output "mymodec2output" {
  value = aws_instance.app_server.private_ip
}
