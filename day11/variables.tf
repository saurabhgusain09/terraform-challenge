variable "project_name" {
  default = "Project ALPHA Resources"
}

variable "default_tags" {
  default = {
    
    managed_by = "saurabh"
  }
}

variable "main_tag" {
  default = {
    project = "Project ALPHA"
    owner = "gusain"
    env ="production"
  }
}


variable "bucket_name" {
  default = "ThisIsUs"
}


variable "allowed_ports" {
  default = "22,80,443,8080"
}


variable "instance_sizes" {
  default = {
    dev = "t2.micro"
    staging = "t3.micro"
    prod = "t2.medium"
  }
}

variable "env" {
  default = "staging"
}