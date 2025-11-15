# -------------------------
# Create VPC
# -------------------------
resource "aws_vpc" "dev_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Dev-VPC"
  }
}

# -------------------------
# Create Public Subnet
# -------------------------
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "Dev-subnet-1-public"
  }
}

# -------------------------
# Create Private Subnet
# -------------------------
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.dev_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "Dev-subnet-2-private"
  }
}

# -------------------------
# Internet Gateway
# -------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.dev_vpc.id
  tags = {
    Name = "Dev-IGW"
  }
}

# -------------------------
# Public Route Table
# -------------------------
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.dev_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "Dev-Public-RT"
  }
}

# -------------------------
# Associate Public Route Table
# -------------------------
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# -------------------------
# Elastic IP for NAT Gateway
# -------------------------
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

# -------------------------
# NAT Gateway
# -------------------------
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id
  tags = {
    Name = "Dev-NAT-Gateway"
  }
}

# -------------------------
# Private Route Table (with NAT)
# -------------------------
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.dev_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
  tags = {
    Name = "Dev-Private-RT"
  }
}

# -------------------------
# Associate Private Route Table
# -------------------------
resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}

# -------------------------
# Security Group
# -------------------------
resource "aws_security_group" "dev_sg" {
  name   = "dev-sg"
  vpc_id = aws_vpc.dev_vpc.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dev-sg"
  }
}

# -------------------------
# EC2 Instances
# -------------------------
resource "aws_instance" "public" {
  ami                         = "ami-0bdd88bd06d16ba03"
  instance_type                = "t2.micro"
  subnet_id                    = aws_subnet.public_subnet.id
  vpc_security_group_ids       = [aws_security_group.dev_sg.id]
  associate_public_ip_address  = true
  tags = {
    Name = "Dev-Public-EC2"
  }
}

resource "aws_instance" "private" {
  ami                         = "ami-0bdd88bd06d16ba03"
  instance_type                = "t2.micro"
  subnet_id                    = aws_subnet.private_subnet.id
  vpc_security_group_ids       = [aws_security_group.dev_sg.id]
  associate_public_ip_address  = false
  tags = {
    Name = "Dev-Private-EC2"
  }
}
