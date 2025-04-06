# VPC
resource "aws_vpc" "demo_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "eks-vpc"
  }
}

# Public Subnet
resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.demo_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "eks-public-subnet-1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.demo_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-southeast-1b"

  tags = {
    Name = "eks-public-subnet-2"
  }
}

# Private Subnet
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.demo_vpc.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "eks-private-subnet-1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.demo_vpc.id
  cidr_block        = "10.0.20.0/24"
  availability_zone = "ap-southeast-1b"

  tags = {
    Name = "eks-private-subnet-2"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "demo_igw" {
  vpc_id = aws_vpc.demo_vpc.id

  tags = {
    Name = "eks-igw"
  }
}

# Elastic IP
resource "aws_eip" "demo_eip" {
  domain = "vpc"

  tags = {
    Name = "eks-eip"
  }
}

# Nat Gateway
resource "aws_nat_gateway" "demo_natgw" {
  connectivity_type = "public"
  allocation_id     = aws_eip.demo_eip.id
  subnet_id         = aws_subnet.public_subnet_1.id

  tags = {
    Name = "eks-natgw"
  }
}

# Route Table
resource "aws_route_table" "demo_public_rtb" {
  vpc_id = aws_vpc.demo_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo_igw.id
  }

  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }

  tags = {
    Name = "eks-public-rtb"
  }
}

resource "aws_route_table" "demo_private_rtb" {
  vpc_id = aws_vpc.demo_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.demo_natgw.id
  }

  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }

  tags = {
    Name = "eks-private-rtb"
  }
}

resource "aws_route_table_association" "public_associate_rtb_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.demo_public_rtb.id
  depends_on     = [aws_subnet.public_subnet_1, aws_route_table.demo_public_rtb]
}

resource "aws_route_table_association" "public_associate_rtb_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.demo_public_rtb.id
  depends_on     = [aws_subnet.public_subnet_2, aws_route_table.demo_public_rtb]
}

resource "aws_route_table_association" "private_associate_rtb_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.demo_private_rtb.id
  depends_on     = [aws_subnet.private_subnet_1, aws_route_table.demo_private_rtb]
}

resource "aws_route_table_association" "private_associate_rtb_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.demo_private_rtb.id
  depends_on     = [aws_subnet.private_subnet_2, aws_route_table.demo_private_rtb]
}

