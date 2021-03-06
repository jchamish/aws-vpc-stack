variable "vpc_ip_address" {}

# create vpc
resource "aws_vpc" "main_vpc" {
    cidr_block = "10.0.0.0/16"  
    assign_generated_ipv6_cidr_block = false
    tags = {
      Name = ""
    }
}

# Subnet one
resource "aws_subnet" "public_subnet_one" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnetOne"
  }
}

# Subnet two
resource "aws_subnet" "public_subnet_two" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnetTwo"
  }
}

# internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "nginx-ig"
  }
}

# update default routing tables
resource "aws_default_route_table" "nginx_route_table" {
  default_route_table_id = aws_vpc.main_vpc.default_route_table_id

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "nginx route table"
  }
}

# connect each subnet to routing table
resource "aws_route_table_association" "add_subnet_one" {
  subnet_id = aws_subnet.public_subnet_one.id
  route_table_id = aws_default_route_table.nginx_route_table.id
}

resource "aws_route_table_association" "add_subnet_two" {
  subnet_id = aws_subnet.public_subnet_two.id
  route_table_id = aws_default_route_table.nginx_route_table.id
}

resource "aws_security_group" "dmz_sg" {
  name        = "dmz_sg"
  description = "DMZ Securtiy Group"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description = "HTTPS protocol"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP protocol"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH protocol"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Ephemeral Port"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dmz_sg"
  }
}




#
output "vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "public_subnet_ids" {
  value = [aws_subnet.public_subnet_one.id, aws_subnet.public_subnet_two.id]
}

output "sg_dmz_id" {
    value = aws_security_group.dmz_sg.id
}