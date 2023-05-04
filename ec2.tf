

module "myec2module" {
  source = "./modules/my-module"
  instance_name = "EC2 Module Demo"
  ami_id = data.aws_ami.amazon_linux_2.id # this is passed from the data defined outside the module
  #ami_id = "ami-069be11a330abe15b"
}