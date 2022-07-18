# Create a VPC
resource "aws_vpc" "softserve" {
  cidr_block = "172.17.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "softserve-VPC"
  }
}

# create subnets in softserve VPC

# create public subnet 1 in AZ a
resource "aws_subnet" "softserve_public1" {
  vpc_id = aws_vpc.softserve.id
  cidr_block = "172.17.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"

  tags = {
    Name = "softserve-public1"
  }
}

# create public subnet 2 en AZ b
resource "aws_subnet" "softserve_public2" {
  vpc_id = aws_vpc.softserve.id
  cidr_block = "172.17.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1b"

  tags = {
    Name = "softserve-public2"
  }
}

# create private subnet 1 AZ a
resource "aws_subnet" "softserve_private1" {
  vpc_id = aws_vpc.softserve.id
  cidr_block = "172.17.3.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"

  tags = {
    Name = "softserve-private1"
  }
}

# create private subnet 2 AZ b
resource "aws_subnet" "softserve_private2" {
  vpc_id = aws_vpc.softserve.id
  cidr_block = "172.17.4.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1b"

  tags = {
    Name = "softserve-private2"
  }
}

# Define internet gateway
resource "aws_internet_gateway" "softserve_IGW" {
  vpc_id = aws_vpc.softserve.id

  tags = {
    "Name" = "softserve_internet-gw"
  }
}

# Define Route tables

# Public Route Table
resource "aws_route_table" "softserve_public_rt" {
  vpc_id = aws_vpc.softserve.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.softserve_IGW.id
  }

  tags = {
    Name = "softserve-public-rt"
  }
}

# Public route table association

resource "aws_route_table_association" "softserve_public1_subnet_rt_association" {
  subnet_id = aws_subnet.softserve_public1.id
  route_table_id = aws_route_table.softserve_public_rt.id
}

resource "aws_route_table_association" "softserve_public2_subnet_rt_association" {
	subnet_id = aws_subnet.softserve_public2.id
	route_table_id = aws_route_table.softserve_public_rt.id
}

# private route table 1
resource "aws_route_table" "softserve_private_rt1" {
	vpc_id = aws_vpc.softserve.id

	tags = {
		"Name" = "private-rt-1"
	}
}

# private route rt 1 association
resource "aws_route_table_association" "softserve_private1_subnet_rt_association" {
	subnet_id = aws_subnet.softserve_private1.id
	route_table_id = aws_route_table.softserve_private_rt1.id
}

# private route table 2
resource "aws_route_table" "softserve_private_rt2" {
	vpc_id = aws_vpc.softserve.id

	tags = {
		"Name" = "private-rt-2"
	}
}

# private route rt 2 association
resource "aws_route_table_association" "softserve_private2_subnet_rt_association" {
	subnet_id = aws_subnet.softserve_private2.id
	route_table_id = aws_route_table.softserve_private_rt2.id
}