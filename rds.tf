# RDS Subnet Group
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = slice(module.vpc.private_subnets, 0, 2)

  tags = {
    Name = "RDS Subnet Group"
  }
}

# Security Group for RDS
resource "aws_security_group" "rds_sg" {
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [module.eks.node_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-security-group"
  }
}

resource "aws_db_instance" "rds" {
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "8.0"
  identifier             = local.rds_name
  instance_class         = "db.t3.micro"
  db_name                = data.aws_ssm_parameter.db_name.value
  username               = data.aws_ssm_parameter.db_username.value
  password               = data.aws_ssm_parameter.db_password.value
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
}
