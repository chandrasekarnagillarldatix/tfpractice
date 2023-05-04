provider "aws" {
    region = "us-west-2"
}

provider "aws" {
    region = "eu-west-1"
    alias = "europe"
}

resource "aws_instance" "app_server" {
  instance_type = "t2.micro"
  ami = "ami-069be11a330abe15b"
}

resource "aws_instance" "db_server" {
    provider = aws.europe
  instance_type = "t2.micro"
  ami = data.aws_ami.amazon_linux_2.id
}

data "aws_ami" "amazon_linux_2" {
    provider = aws.europe
 most_recent = true
 filter {
   name   = "owner-alias"
   values = ["amazon"]
 }
 filter {
   name   = "name"
   values = ["amzn2-ami-hvm*"]
 }
}