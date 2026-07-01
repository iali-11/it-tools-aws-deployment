resource "aws_vpc" "it_tools_vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "it-tools-vpc"
  }
}

resource "aws_subnet" "it_tools_public_subnets" {
  count = 2

  vpc_id            = aws_vpc.it_tools_vpc.id
  cidr_block        = var.public_subnet_cidr_blocks[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "it_tools_private_subnets" {
  count = 2

  vpc_id            = aws_vpc.it_tools_vpc.id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "it_tools_igw" {
  vpc_id = aws_vpc.it_tools_vpc.id

  tags = {
    Name = "igw"
  }
}

resource "aws_eip" "it_tools_eip" {
  domain = "vpc"

  tags = {
    Name = "eip-natgw"
  }
}

resource "aws_nat_gateway" "it_tools_natgw" {
  allocation_id = aws_eip.it_tools_eip.id
  subnet_id     = aws_subnet.it_tools_public_subnets[0].id

  tags = {
    Name = "natgw"
  }

  depends_on = [aws_internet_gateway.it_tools_igw]
}

resource "aws_route_table" "it_tools_public_route_table" {
  vpc_id = aws_vpc.it_tools_vpc.id

  route {
    cidr_block = var.vpc_cidr_block
    gateway_id = "local"
  }

  route {
    cidr_block = var.default_cidr_block
    gateway_id = aws_internet_gateway.it_tools_igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table" "it_tools_private_route_table" {
  vpc_id = aws_vpc.it_tools_vpc.id

  route {
    cidr_block = var.vpc_cidr_block
    gateway_id = "local"
  }

  route {
    cidr_block = var.default_cidr_block
    gateway_id = aws_nat_gateway.it_tools_natgw.id
  }

  tags = {
    Name = "private-route-table"
  }
}

resource "aws_route_table_association" "public" {
  count = 2

  subnet_id      = aws_subnet.it_tools_public_subnets[count.index].id
  route_table_id = aws_route_table.it_tools_public_route_table.id
}

resource "aws_route_table_association" "private" {
  count = 2

  subnet_id      = aws_subnet.it_tools_private_subnets[count.index].id
  route_table_id = aws_route_table.it_tools_private_route_table.id
}