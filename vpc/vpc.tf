# create vpc
variable "vpc_ip_address" { type = list(string) }
variable "vpc_name" { type = string }

resource "aws_vpc" "main_vpc" {
    cidr_block = "${join('.', vpc_ip_address)}/16"
    assign_generated_ipv6_cidr_block = true
    tags = {
      Name = var.vpc_name
    }
}

# internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.vpc_name}-ig"
  }
}

# update default routing tables
resource "aws_default_route_table" "route_table" {
  default_route_table_id = aws_vpc.main_vpc.default_route_table_id

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.vpc_name} route table"
  }
}

# output the vpc id
output "vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "route_table_id" {
  value = aws_default_route_table.route_table.id
}