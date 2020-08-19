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

# connect each subnet to routing table
resource "aws_route_table_association" "add_subnet_one" {
  subnet_id = aws_subnet.public_subnet_one.id
  route_table_id = aws_default_route_table.nginx_route_table.id
}

resource "aws_route_table_association" "add_subnet_two" {
  subnet_id = aws_subnet.public_subnet_two.id
  route_table_id = aws_default_route_table.nginx_route_table.id
}


output "public_subnet_ids" {
  value = [aws_subnet.public_subnet_one.id, aws_subnet.public_subnet_two.id]
}

output "sg_dmz_id" {
    value = aws_security_group.dmz_sg.id
}