# resource "aws_instance" "saurabh" {
#   ami = "ami-0317b0f0a0144b137"
#   instance_type = var.type_of_instance[0]
#   region = var.region

#   tags = {
#     Name = "GusainServer"
#   }
#   lifecycle {
#     create_before_destroy = true
#     ignore_changes = [ 
#       tags
#      ]
#   }

 
# }


resource "aws_security_group" "app_sg" {
  name = "my-secuurity-group"
  description = "Allow Traffic to instances"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.allow_cidr[0]]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [var.allow_cidr[1]]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "app_with_SG" {
  ami = "ami-0317b0f0a0144b137"
  instance_type = var.type_of_instance[0]
  vpc_security_group_ids = [ aws_security_group.app_sg.id ]
  tags = var.tags


  lifecycle {
    replace_triggered_by = [ aws_security_group.app_sg ]
  }
}