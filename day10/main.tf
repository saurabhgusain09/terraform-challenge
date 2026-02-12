resource "aws_instance" "example" {
  ami           = "ami-0317b0f0a0144b137"
  count = var.instance_count
  # instance_type = "t2.micro"
  instance_type = var.env == "prod" ? "t2.micro" : "t2.medium"
  
  tags = var.tags
}


# resource "aws_security_group" "mysg" {
#   name   = "sg"
#   # vpc_id = aws_vpc.example.id
#   ingress {
#     from_port = 80
#     to_port = 80
#     protocol = "tcp" 
#     cidr_blocks = ["0.0.0.0/0"]
# description = "Allow HTTP traffic from anywhere"

#   }
#   ingress {
#     from_port = 443
#     to_port = 443
#     protocol = "tcp" 
#     cidr_blocks = ["0.0.0.0/0"]
#     description = "Allow HTTPS traffic from anywhere"
#   }
# }


resource "aws_security_group" "mysg" {
  name   = "sg"
  # vpc_id = aws_vpc.example.id
  dynamic   "ingress" {
    for_each = var.ingressrules 
    content {
      from_port = ingress.value.from_port
      to_port = ingress.value.to_port
      protocol = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_block
      description = ingress.value.description

  }
  }
}


locals {
  all_instances_publicIP = aws_instance.example[*].public_ip
}