# create vpc
resource "aws_vpc" "main_vpc" {
    cidr_block = "10.0.0.0/16"
    assign_generated_ipv6_cidr_block = false
    tags = {
      Name = "nginx-vpc"
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





#
output "vpc_id" {
  value = aws_vpc.main_vpc.id
}