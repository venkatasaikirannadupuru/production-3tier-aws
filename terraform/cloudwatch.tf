# ============================================================
# CloudWatch Log Group
# ============================================================

resource "aws_cloudwatch_log_group" "app" {
  name              = "/production-3tier/app"
  retention_in_days = 7

  tags = {
    Name = "production-3tier-app-logs"
  }
}

# ============================================================
# CloudWatch Alarm - High CPU
# ============================================================

resource "aws_cloudwatch_metric_alarm" "app_high_cpu" {
  alarm_name          = "production-3tier-app-high-cpu"
  alarm_description   = "Triggers when application EC2 CPU usage is high"
  comparison_operator = "GreaterThanThreshold"

  evaluation_periods = 2
  metric_name        = "CPUUtilization"
  namespace          = "AWS/EC2"
  period             = 300
  statistic          = "Average"
  threshold          = 70

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app.name
  }

  treat_missing_data = "notBreaching"

  tags = {
    Name = "production-3tier-high-cpu-alarm"
  }
}

