variable "env" {
  default = "dev"
}

variable "instance_count" {
  description = "numbers of instances to be create"
  type = number
}

# variable "region" {
#   type = string

# }

variable "instance_monitoring" {
  type = bool
  default = false
}

variable "instance_public_ip" {
  type = bool
  default = false
}

variable "allow_cidr" {
  description = "cidr block for our vpc"
  type = list(string)
  default = [ "10.0.0.0/8","192.168.0.0/16","172.16.0.0/12" ]
}

variable "type_of_instance" {
  type = list(string)
  default = [ "t2.micro", "t2.small", "t2.medium" ]
}

variable "allowed_region" {
  description = "allowed region for our infrastructure"
  type = set(string)
  default = ["ap-south-1","ap-south-2","us-east-1" ]
}

variable "region" {
  description = "region to deploy infrastructure"
  type = string

  validation {
    condition = contains(var.allowed_region, var.region)
    error_message = "the value you type is wrong"
  }
}

variable "tags" {
  type = map(string) 
  default = {
    Name = "FirstInstance"
    Environment = "dev"
  }
}

variable "ingress_rules" {
  type = tuple([ number, string,number ])
  default = [ 80, "tcp", 80 ]
}


variable "config" {
  type = object({
    region = string
    instance_count = number
    instance_monitoring = bool

  })
  default = {
    region = "ap-south-1"
    instance_count = 1
    instance_monitoring = false
  }
}