# Import existing VPC
resource "aws_vpc" "existing" {
  cidr_block           = "10.100.0.0/20" # Use actual CIDR from Phase 0 discovery
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "test-vpc" # Actual tag from AWS
  }
}

# Import existing public subnets (for ALB)
resource "aws_subnet" "public_1a" {
  vpc_id            = aws_vpc.existing.id
  cidr_block        = "10.100.10.0/24" # Actual CIDR from discovery
  availability_zone = "us-east-1a"

  tags = {
    Name = "test-subnet-public1-us-east-1a"
  }
}

resource "aws_subnet" "public_1b" {
  vpc_id            = aws_vpc.existing.id
  cidr_block        = "10.100.11.0/24" # Actual CIDR from discovery
  availability_zone = "us-east-1b"

  tags = {
    Name = "test-subnet-public2-us-east-1b"
  }
}

# Import existing private subnets (for EC2/Fargate)
resource "aws_subnet" "private_1a" {
  vpc_id            = aws_vpc.existing.id
  cidr_block        = "10.100.14.0/24" # Actual CIDR from discovery
  availability_zone = "us-east-1a"

  tags = {
    Name = "test-subnet-private1-us-east-1a"
  }
}

resource "aws_subnet" "private_1b" {
  vpc_id            = aws_vpc.existing.id
  cidr_block        = "10.100.15.0/24" # Actual CIDR from discovery
  availability_zone = "us-east-1b"

  tags = {
    Name = "test-subnet-private2-us-east-1b"
  }
}

# Import Internet Gateway
resource "aws_internet_gateway" "existing" {
  vpc_id = aws_vpc.existing.id

  tags = {
    Name = "test-igw"
  }
}

# NAT Gateways - one per AZ for high availability
resource "aws_eip" "nat_1a" {
  domain = "vpc"

  tags = {
    Name = "nat-eip-1a"
  }
}

resource "aws_eip" "nat_1b" {
  domain = "vpc"

  tags = {
    Name = "nat-eip-1b"
  }
}

resource "aws_nat_gateway" "nat_1a" {
  allocation_id = aws_eip.nat_1a.id
  subnet_id     = aws_subnet.public_1a.id

  tags = {
    Name = "nat-gateway-1a"
  }
}

resource "aws_nat_gateway" "nat_1b" {
  allocation_id = aws_eip.nat_1b.id
  subnet_id     = aws_subnet.public_1b.id

  tags = {
    Name = "nat-gateway-1b"
  }
}

# Import route tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.existing.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.existing.id
  }

  tags = {
    Name = "test-rtb-public"
  }
}

# Separate private route tables per AZ (for NAT Gateway failover)
resource "aws_route_table" "private_1a" {
  vpc_id = aws_vpc.existing.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_1a.id
  }

  tags = {
    Name = "test-rtb-private1-us-east-1a"
  }
}

resource "aws_route_table" "private_1b" {
  vpc_id = aws_vpc.existing.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_1b.id
  }

  tags = {
    Name = "test-rtb-private2-us-east-1b"
  }
}

# Route table associations
resource "aws_route_table_association" "public_1a" {
  subnet_id      = aws_subnet.public_1a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_1b" {
  subnet_id      = aws_subnet.public_1b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_1a" {
  subnet_id      = aws_subnet.private_1a.id
  route_table_id = aws_route_table.private_1a.id
}

resource "aws_route_table_association" "private_1b" {
  subnet_id      = aws_subnet.private_1b.id
  route_table_id = aws_route_table.private_1b.id
}
