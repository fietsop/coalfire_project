# Create Subnets
resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.1.0.0/24"
  availability_zone = "us-east-2a"
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.1.1.0/24"
  availability_zone = "us-east-2b"
}

resource "aws_subnet" "wp_subnet_1" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.1.2.0/24"
  availability_zone = "us-east-2a" 
}

resource "aws_subnet" "wp_subnet_2" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.1.3.0/24"
  availability_zone = "us-east-2b" 
}

resource "aws_subnet" "db_subnet_1" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.1.4.0/24"
  availability_zone = "us-east-2a" 
}

resource "aws_subnet" "db_subnet_2" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.1.5.0/24"
  availability_zone = "us-east-2b"
}

