# ============================================================
# RDS Subnet Group
# ============================================================

resource "aws_db_subnet_group" "main" {
  name = "production-3tier-db-subnet-group"

  subnet_ids = [
    aws_subnet.db_1.id,
    aws_subnet.db_2.id
  ]

  tags = {
    Name = "production-3tier-db-subnet-group"
  }
}

# ============================================================
# RDS PostgreSQL
# ============================================================

resource "aws_db_instance" "postgres" {
  identifier = "production-3tier-postgres"

  engine         = "postgres"
  engine_version = "16"

  instance_class        = "db.t3.micro"
  allocated_storage     = 20
  max_allocated_storage = 50
  storage_type          = "gp3"

  db_name  = "productiondb"
  username = var.db_username
  password = var.db_password

  db_subnet_group_name = aws_db_subnet_group.main.name

  vpc_security_group_ids = [
    aws_security_group.db.id
  ]

  publicly_accessible = false

  multi_az = false

  backup_retention_period = 1

  skip_final_snapshot = true

  deletion_protection = false

  tags = {
    Name = "production-3tier-postgres"
  }
}
