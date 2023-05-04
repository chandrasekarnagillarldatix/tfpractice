provider "aws" {
    region = "us-west-2"
}

resource "aws_instance" "app_server" {
  count = 2

  instance_type = "t2.micro"
  ami = "ami-069be11a330abe15b"

    tags = merge(var.common_tags, {Name = join("-",["myMachine",count.index] )})

}

variable "common_tags" {
type = map
default = {
    client = "ASL"
    bu = "flex"
}
}

