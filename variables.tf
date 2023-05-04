variable "client" {
    type = string
    default = "ASW"
    description = "Name of the client. This can be used as prefix/postfix for resource names."
}

variable "region_short" {
    type = string
    default = "USW2"
}

variable "ec2name" {
      type = string
      description = "Name of the EC2 Instance"
}

variable "tags" {
    type = map
    description = "Tags used to identify this instance and its metadata"
}

variable "ingressports" {
    type = list(number)
    default = [ 22, 443 ]
}

variable "egressports" {
    type = list(number)
    default = [ 22, 443, 80, 53 ]
}