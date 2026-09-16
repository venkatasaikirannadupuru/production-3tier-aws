# ============================================================
# Jenkins IAM Role
# ============================================================

resource "aws_iam_role" "jenkins" {
  name = "production-3tier-jenkins-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "production-3tier-jenkins-role"
  }
}

# ============================================================
# Jenkins EC2 Instance Profile
# ============================================================

resource "aws_iam_instance_profile" "jenkins" {
  name = "production-3tier-jenkins-profile"
  role = aws_iam_role.jenkins.name
}
# ============================================================
# Application EC2 IAM Role
# ============================================================

resource "aws_iam_role" "app" {
  name = "production-3tier-app-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "production-3tier-app-role"
  }
}

# ============================================================
# Allow EC2 to Pull Images from ECR
# ============================================================

resource "aws_iam_role_policy_attachment" "app_ecr_readonly" {
  role       = aws_iam_role.app.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# ============================================================
# EC2 Instance Profile
# ============================================================

resource "aws_iam_instance_profile" "app" {
  name = "production-3tier-app-profile"
  role = aws_iam_role.app.name
}
