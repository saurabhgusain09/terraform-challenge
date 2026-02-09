#creation of ec2 instance

resource "aws_instance" "myinstance" {
  count = var.instance_count
  ami = "ami-0ff5003538b60d5ec"
  instance_type = var.type_of_instance[0]
  
  monitoring = var.config.instance_monitoring
  associate_public_ip_address = var.instance_public_ip
    tags = var.tags

}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = var.allow_cidr[2]
  from_port         = var.ingress_rules[0]
  ip_protocol       = var.ingress_rules[1]
  to_port           = var.ingress_rules[2]
}



resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

