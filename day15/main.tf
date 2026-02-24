# ---------------- VPC ----------------

resource "aws_vpc" "primary" {
  provider   = aws.primary
  cidr_block = var.primary_vpc_cidr
  tags = { Name = "Primary-VPC" }
}

resource "aws_vpc" "secondary" {
  provider   = aws.secondary
  cidr_block = var.secondary_vpc_cidr
  tags = { Name = "Secondary-VPC" }
}

# ---------------- Subnets ----------------

resource "aws_subnet" "primary" {
  provider          = aws.primary
  vpc_id            = aws_vpc.primary.id
  cidr_block        = var.primary_subnet_cidr
  map_public_ip_on_launch = true
}

resource "aws_subnet" "secondary" {
  provider          = aws.secondary
  vpc_id            = aws_vpc.secondary.id
  cidr_block        = var.secondary_subnet_cidr
  map_public_ip_on_launch = true
}

# ---------------- IGW ----------------

resource "aws_internet_gateway" "primary" {
  provider = aws.primary
  vpc_id   = aws_vpc.primary.id
}

resource "aws_internet_gateway" "secondary" {
  provider = aws.secondary
  vpc_id   = aws_vpc.secondary.id
}

# ---------------- Route Tables ----------------

resource "aws_route_table" "primary" {
  provider = aws.primary
  vpc_id   = aws_vpc.primary.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.primary.id
  }
}

resource "aws_route_table" "secondary" {
  provider = aws.secondary
  vpc_id   = aws_vpc.secondary.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.secondary.id
  }
}

resource "aws_route_table_association" "primary" {
  provider       = aws.primary
  subnet_id      = aws_subnet.primary.id
  route_table_id = aws_route_table.primary.id
}

resource "aws_route_table_association" "secondary" {
  provider       = aws.secondary
  subnet_id      = aws_subnet.secondary.id
  route_table_id = aws_route_table.secondary.id
}

# ---------------- VPC Peering ----------------

resource "aws_vpc_peering_connection" "peer" {
  provider     = aws.primary
  vpc_id       = aws_vpc.primary.id
  peer_vpc_id  = aws_vpc.secondary.id
  peer_region  = var.secondary
  auto_accept  = false
}

resource "aws_vpc_peering_connection_accepter" "accept" {
  provider                  = aws.secondary
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  auto_accept               = true
}

# Routes for Peering

resource "aws_route" "primary_to_secondary" {
  provider                  = aws.primary
  route_table_id            = aws_route_table.primary.id
  destination_cidr_block    = var.secondary_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}

resource "aws_route" "secondary_to_primary" {
  provider                  = aws.secondary
  route_table_id            = aws_route_table.secondary.id
  destination_cidr_block    = var.primary_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}

# ---------------- Security Groups ----------------

resource "aws_security_group" "primary" {
  provider = aws.primary
  vpc_id   = aws_vpc.primary.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.secondary_vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "secondary" {
  provider = aws.secondary
  vpc_id   = aws_vpc.secondary.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.primary_vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ---------------- EC2 ----------------

resource "aws_instance" "primary" {
  provider               = aws.primary
  ami                    = data.aws_ami.ubuntu_primary.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.primary.id
  vpc_security_group_ids = [aws_security_group.primary.id]
  key_name               = var.primary_key_name
}

resource "aws_instance" "secondary" {
  provider               = aws.secondary
  ami                    = data.aws_ami.ubuntu_secondary.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.secondary.id
  vpc_security_group_ids = [aws_security_group.secondary.id]
  key_name               = var.secondary_key_name
}