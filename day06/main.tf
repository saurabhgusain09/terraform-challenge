








#creation of s3 bucket
resource "aws_s3_bucket" "mybucket" {
  bucket = "gusainjikibucket${local.naming}"
    tags = {
        Name        = "My bucket v2"
        Environment = var.env
    }
}

#creation of vpc 

resource "aws_vpc" "myvpc" {
  cidr_block = "192.168.0.0/24"
    tags = {
        Name = "myvpc"
        Environment = var.env
    }
}


#creation of ec2 instance

resource "aws_instance" "myinstance" {
  ami = "ami-0ff5003538b60d5ec"
    instance_type = "t2.micro"

    tags = {
      Name = "FirstInstance"
      Environment = var.env
    }
}