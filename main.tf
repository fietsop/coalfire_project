provider "aws" {
  region = "us-east-2" 
}

# Create VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.1.0.0/16"
}

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

# Create Internet Gateway
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id
}

# Create Route Tables
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }
}

resource "aws_route_table" "wp_rt" {
  vpc_id = aws_vpc.main_vpc.id
}

# Associate Subnets with Route Tables
resource "aws_route_table_association" "public_subnet_1_association" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_subnet_2_association" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "wp_subnet_1_association" {
  subnet_id      = aws_subnet.wp_subnet_1.id
  route_table_id = aws_route_table.wp_rt.id
}

resource "aws_route_table_association" "wp_subnet_2_association" {
  subnet_id      = aws_subnet.wp_subnet_2.id
  route_table_id = aws_route_table.wp_rt.id
}

# Create Security Group
resource "aws_security_group" "bastion_sg" {
  vpc_id = aws_vpc.main_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
}
resource "aws_security_group" "wp_server" {
  vpc_id = aws_vpc.main_vpc.id


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }
  
}


# Create EC2 Instances
resource "aws_instance" "bastion_instance" {
  ami           = "ami-094aa6728b151e05a" 
  instance_type = "t3a.medium"
  subnet_id     = aws_subnet.public_subnet_2.id             
  associate_public_ip_address = true
  security_groups = [aws_security_group.bastion_sg.id]

 user_data = <<-EOF
    <powershell>
    # Replace 'newusername' and 'newuserpassword' with desired values
    $Username = "alain"
    $Password = ConvertTo-SecureString -String "Alinosec87@" -AsPlainText -Force
    New-LocalUser -Name $Username -Password $Password -FullName "New User" -Description "Created by Terraform" -UserMayNotChangePassword -PasswordNeverExpires
    Add-LocalGroupMember -Group "Administrators" -Member $Username
    </powershell>
  EOF

  tags = {
    "Name" = "bastion1"
  }
}
  
resource "aws_instance" "wp_server_1" {
  ami           = "ami-0d77c9d87c7e619f9"
  instance_type = "t3a.micro"
  subnet_id     = aws_subnet.wp_subnet_1.id
  connection {
    type = "ssh"
    user = "ec2-user"
    password = var.ssh_key_name
    host = self.private_ip
  }
  tags = {
    Name = "wpserver1"
  }
  root_block_device {
    volume_size = 20
  }
  security_groups = [aws_security_group.wp_server.id]
}

resource "aws_instance" "wp_server_2" {
  ami           = "ami-0d77c9d87c7e619f9" 
  instance_type = "t3a.micro"
  subnet_id     = aws_subnet.wp_subnet_2.id
  connection {
    type = "ssh"
    user = "ec2-user"
    password = var.ssh_key_name
    host = self.private_ip
  }
  tags = {
    Name = "wpserver2"
  }
  root_block_device {
    volume_size = 20
  }
security_groups = [aws_security_group.wp_server.id]
}
resource "aws_security_group" "rds_sg" {
  vpc_id = aws_vpc.main_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_db_subnet_group" "project_db_subnet_group" {
  name = "project_db_subnet_group"
  subnet_ids = [aws_subnet.db_subnet_2.id, aws_subnet.db_subnet_1.id]
  
}

# Create RDS Instance
 resource "aws_db_instance" "rds_instance" {
  engine               = "postgres"
  instance_class       = "db.t3.micro"
  db_name = "RDS1"
  username = "alain"
  password = "alinosec"
  identifier = "coalfire-db"
  db_subnet_group_name = aws_db_subnet_group.project_db_subnet_group.name
  allocated_storage    = 20
  storage_type         = "gp2"
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}


# Create ALB
resource "aws_lb" "main_alb" {
  name               = "main-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
}

# Create ALB Listener
resource "aws_lb_listener" "main_alb_listener" {
  load_balancer_arn = aws_lb.main_alb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn = "arn:aws:acm:us-east-2:112149621461:certificate/49c8d06c-affb-4989-b3f0-f7c1cf81961b"
  default_action {
  type             = "forward"
  target_group_arn = aws_lb_target_group.wp_target_group.arn
  }
}

# Create ALB Target Group
resource "aws_lb_target_group" "wp_target_group" {
  name        = "wp-target-group"
  port        = 443
  protocol    = "HTTPS"
  vpc_id      = aws_vpc.main_vpc.id
  target_type = "instance"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    path                = "/"
    matcher             = "200-399"
  }
}

# ALB Target Group Attachment
resource "aws_lb_target_group_attachment" "wp_target_group_attachment" {
  target_group_arn = aws_lb_target_group.wp_target_group.arn
  target_id        = aws_instance.wp_server_1.id
}




 