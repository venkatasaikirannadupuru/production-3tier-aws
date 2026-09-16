variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "db_username" {
  description = "RDS database username"
  type        = string
  default     = "appadmin"
}

variable "db_password" {
  description = "RDS database password"
  type        = string
  sensitive   = true
}
