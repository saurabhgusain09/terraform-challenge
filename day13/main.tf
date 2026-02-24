
data "aws_vpc" "existing_vpc" {
  filter {
    name = "tag:Name"
    values = [ "gusain_vpc" ]
  }
}

data "aws_subnet" "existing_subnet" {
  filter {
    name = "tag:Name"
    values = ["subnet-1" ]
  }
  vpc_id = data.aws_vpc.existing_vpc.id
}

data "aws_ami" "linux" {
  owners = [ "amazon" ]
  most_recent = true
  filter {
    name = "name"
    values = [ "al2023-ami-*-x86_64" ]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

resource "aws_instance" "my_instance" {
  ami = data.aws_ami.linux.id
  instance_type = "t2.micro"
  subnet_id = data.aws_subnet.existing_subnet.id
  
}