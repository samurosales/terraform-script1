# Create a VPC
data "aws_availability_zones" "all" {}

resource "aws_vpc" "sr-vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "sr-new2-vpc"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.sr-vpc.id

  tags = {
    Name = "sr-igw"
  }
}

resource "aws_subnet" "private_subnets" {
  
  vpc_id     = aws_vpc.sr-vpc.id
  count      = length(data.aws_availability_zones.all.names)

  cidr_block = cidrsubnet(var.vpc_cidr, 4, count.index)
  availability_zone = data.aws_availability_zones.all.names[count.index]
  tags = {
    Name = "sr-private_subnet${count.index}"
  }
}

resource "aws_subnet" "public_subnets" {

  vpc_id     = aws_vpc.sr-vpc.id
  count      = length(data.aws_availability_zones.all.names)

  cidr_block = cidrsubnet(var.vpc_cidr, 4, count.index + length(data.aws_availability_zones.all.names))
  availability_zone = data.aws_availability_zones.all.names[count.index]

  tags = {
    Name = "sr-public_subnet${count.index}"
  }
}

resource "aws_eip" "nat_eip" {
  depends_on = [aws_internet_gateway.gw]
  tags = {
    Name = "sr-eip"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnets[0].id

  tags = {
    Name = "sr-nat-gw"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}


resource "aws_route_table" "prv_rTable" {
  vpc_id = aws_vpc.sr-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "sr-private-rTable"
  }
}

resource "aws_route_table_association" "prv_rTable_subnets" {
  count          = length(aws_subnet.private_subnets)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.prv_rTable.id
}


resource "aws_route_table" "pub_rTable" {
  vpc_id = aws_vpc.sr-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "sr-public-rTable"
  }
}


resource "aws_route_table_association" "pub_rTable_subnets" {
  count          = length(aws_subnet.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.pub_rTable.id
}
