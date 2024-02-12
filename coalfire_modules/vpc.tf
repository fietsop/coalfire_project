provider "aws" {
  region = "us-east-2"
}
# Create VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.1.0.0/16"
}
