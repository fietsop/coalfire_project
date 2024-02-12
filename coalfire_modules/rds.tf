# Create RDS Instance
resource "aws_db_instance" "rds_instance" {
  engine               = "postgres"
  instance_class       = "db.t3.micro"
  db_name              = "RDS1"
  username             = "alain"
  password             = "alinosec"
  identifier           = "coalfire-db"
  db_subnet_group_name = aws_db_subnet_group.project_db_subnet_group.name
  allocated_storage    = 20
  storage_type         = "gp2"
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}


