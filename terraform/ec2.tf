data "aws_caller_identity" "current" {}
# ============================================================
# Latest Amazon Linux 2023 AMI
# ============================================================

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# ============================================================
# Launch Template
# ============================================================

resource "aws_launch_template" "app" {
  name_prefix   = "production-3tier-app-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  vpc_security_group_ids = [
    aws_security_group.app.id
  ]

  iam_instance_profile {
    name = aws_iam_instance_profile.app.name
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash

    set -e

    # Install Docker and AWS CLI
    dnf update -y
    dnf install -y docker awscli

    # Start Docker
    systemctl enable docker
    systemctl start docker

    # Allow ec2-user to use Docker
    usermod -aG docker ec2-user

    # Login to ECR
    aws ecr get-login-password --region ap-south-1 | \
      docker login --username AWS --password-stdin \
      ${data.aws_caller_identity.current.account_id}.dkr.ecr.ap-south-1.amazonaws.com

    # Pull application image
    docker pull \
      ${data.aws_caller_identity.current.account_id}.dkr.ecr.ap-south-1.amazonaws.com/production-3tier-app:latest

    # Stop old container if present
    docker rm -f production-3tier-app || true

    # Run application container
    docker run -d \
      --name production-3tier-app \
      --restart always \
      -p 80:80 \
      ${data.aws_caller_identity.current.account_id}.dkr.ecr.ap-south-1.amazonaws.com/production-3tier-app:latest
  EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "production-3tier-app-server"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# ============================================================
# Auto Scaling Group
# ============================================================

resource "aws_autoscaling_group" "app" {
  name = "production-3tier-app-asg"

  min_size         = 2
  max_size         = 4
  desired_capacity = 2

  vpc_zone_identifier = [
    aws_subnet.app_1.id,
    aws_subnet.app_2.id
  ]

  target_group_arns = [
    aws_lb_target_group.app.arn
  ]

  health_check_type = "ELB"

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "production-3tier-app-server"
    propagate_at_launch = true
  }
}
