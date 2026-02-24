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
  default = "dev"
}

variable "instance_type" {
  default = "t2.micro"

  validation {
    condition = length(var.instance_type)>=2 && length(var.instance_type) <=20
    error_message = "instance type must be between 2 to 20 characters"
  }

  validation {
    condition = can(regex("^t[2-3]\\.",var.instance_type))
    error_message = "instance must be start with t2 or t3"
  }
}

variable "backup" {
  default = "backup_server"
  validation {
    condition = endswith(var.backup,"_server")
    error_message = "backup must contains _server at last"
  }
}

variable "credentials" {
  default = "xyz123"
  sensitive = true
}

variable "user_location" {
  default = ["us-east-1", "us-west-2" , "us-east-1"]
}

variable "default_location" {
  default = ["ap-south-1"]
}

variable "monthly_costs" {
  default = [-50,100,75,200]
}

