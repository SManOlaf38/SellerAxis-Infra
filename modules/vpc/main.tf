resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.vpc_name}-${var.environment_name}"
    Environment = var.environment_name
  }
}

# Subnets
resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnet_cidr_block)

  vpc_id     = aws_vpc.main.id
  cidr_block = element(var.public_subnet_cidr_block, count.index)

  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "public_subnet_${count.index}"
  }
}
# End Subnets

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

# Public Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_rt_association" {
  count = length(aws_subnet.public_subnet.*.id)

  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public_route_table.id
}
