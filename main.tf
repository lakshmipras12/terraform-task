provider "aws" {
  profile = "terraform"
  region  = "ap-south-1"
}

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "terraform"
  }
}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "internet-gateway"
  }
}

resource "aws_subnet" "subnet_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "subnet"
  }
}

resource "aws_subnet" "subnet_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "subnet2"
  }
}

resource "aws_subnet" "subnet_3" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-south-1c"

  tags = {
    Name = "subnet3"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "route-table"
  }
}

resource "aws_route" "routing" {
  route_table_id         = aws_route_table.route_table.id
  destination_cidr_block = "0.0.0.0/0" # Route all traffic to the Internet Gateway
  gateway_id             = aws_internet_gateway.main_igw.id
}

resource "aws_route_table_association" "subnet_assoc_1" {
  subnet_id      = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "subnet_assoc_2" {
  subnet_id      = aws_subnet.subnet_2.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "subnet_assoc_3" {
  subnet_id      = aws_subnet.subnet_3.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_instance" "terraform_1" {
  ami                         = "ami-0a7cf821b91bcccbc"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.subnet_1.id
  key_name                    = "terrakey"
  associate_public_ip_address = true

  tags = {
    Name = "terraform task1"
  }
}

resource "aws_instance" "terraform_2" {
  ami                         = "ami-0a7cf821b91bcccbc"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.subnet_2.id
  key_name                    = "terrakey"
  associate_public_ip_address = true

  tags = {
    Name = "terraform task2"
  }
}
