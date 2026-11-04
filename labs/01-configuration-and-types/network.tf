resource "aws_vpc" "lab" {
  cidr_block = "10.0.0.0/16"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name    = "eks-lab-vpc"
    Project = "eks-lab"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "lab_a" {
  vpc_id                  = aws_vpc.lab.id
  cidr_block              = local.lab_subnets.a.cidr_block
  availability_zone       = local.lab_subnets.a.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name    = "eks-lab-subnet-a"
    Project = "eks-lab"
  }
}

resource "aws_subnet" "lab_b" {
  vpc_id                  = aws_vpc.lab.id
  cidr_block              = local.lab_subnets.b.cidr_block
  availability_zone       = local.lab_subnets.b.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name    = "eks-lab-subnet-b"
    Project = "eks-lab"
  }
}

resource "aws_internet_gateway" "lab" {
  vpc_id = aws_vpc.lab.id

  tags = {
    Name    = "eks-lab-ipw"
    Project = "eks-lab"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.lab.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lab.id
  }

  tags = {
    Name    = "eks-lab-public"
    Project = "eks-lab"
  }
}

resource "aws_route_table_association" "lab_a" {
  subnet_id      = aws_subnet.lab_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "lab_b" {
  subnet_id      = aws_subnet.lab_b.id
  route_table_id = aws_route_table.public.id
}
