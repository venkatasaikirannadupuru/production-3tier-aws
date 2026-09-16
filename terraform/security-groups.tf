# ============================================================
# ALB Security Group
# ============================================================

resource "aws_security_group" "alb" {
  name        = "production-3tier-alb-sg"
  description = "Security group for Application Load Balancer"
  vpc_id      = aws_vpc.main.id

  # Allow HTTP traffic from the Internet
  ingress {
    description = "Allow HTTP from Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow outbound traffic
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "production-3tier-alb-sg"
  }
}


# ============================================================
# Application / EC2 Security Group
# ============================================================

resource "aws_security_group" "app" {
  name        = "production-3tier-app-sg"
  description = "Security group for application servers"
  vpc_id      = aws_vpc.main.id

  # Allow HTTP traffic only from the ALB
  ingress {
    description     = "Allow HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  # Allow outbound traffic
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "production-3tier-app-sg"
  }
}


# ============================================================
# Database / RDS Security Group
# ============================================================

resource "aws_security_group" "db" {
  name        = "production-3tier-db-sg"
  description = "Security group for RDS PostgreSQL"
  vpc_id      = aws_vpc.main.id

  # Allow PostgreSQL traffic only from application servers
  ingress {
    description     = "Allow PostgreSQL from Application Servers"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id]
  }

  # Allow outbound traffic
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "production-3tier-db-sg"
  }
}
