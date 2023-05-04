provider "aws" {

    region = "us-west-2"
  
}

resource "aws_instance" "app_server" {
  count = 2

  instance_type = "t2.micro"
  ami = "ami-069be11a330abe15b"
}