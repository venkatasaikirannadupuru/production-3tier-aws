# ============================================================
# VPC Output
# ============================================================

output "vpc_id" {
  description = "ID of the production VPC"
  value       = aws_vpc.main.id
}

# ============================================================
# ALB DNS Name
# ============================================================

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.app.dns_name
}

# ============================================================
# Auto Scaling Group
# ============================================================

output "autoscaling_group_name" {
  description = "Name of the application Auto Scaling Group"
  value       = aws_autoscaling_group.app.name
}

# ============================================================
# RDS Endpoint
# ============================================================

output "rds_endpoint" {
  description = "RDS PostgreSQL endpoint"
  value       = aws_db_instance.postgres.endpoint
}

# ============================================================
# RDS Database Name
# ============================================================

output "rds_database_name" {
  description = "RDS PostgreSQL database name"
  value       = aws_db_instance.postgres.db_name
}
