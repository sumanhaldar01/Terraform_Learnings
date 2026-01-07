resource "aws_cloudwatch_metric_alarm" "Tf_alarm" {
  alarm_name          = "High_CPU_Utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "75"

  dimensions = {
    InstanceId = "i-0abcd1234efgh5678"
  }

  alarm_description = "This metric monitors EC2 CPU utilization"
  #alarm_actions     = ["arn:aws:sns:us-east-1:123456789012:my-sns-topic"]
  }