output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.web_alb.dns_name
}

output "cloudfront_distribution_domain" {
  description = "Domain name of the CloudFront distribution"
  value       = aws_cloudfront_distribution.web_distribution.domain_name
}

output "rds_endpoint" {
  description = "RDS database endpoint"
  value       = aws_db_instance.rds_instance.endpoint
}

output "rds_secret_arn" {
  description = "ARN of the Secrets Manager secret storing RDS credentials"
  value       = aws_secretsmanager_secret.rds_secret.arn
}

output "kms_key_id" {
  description = "KMS key ID used for secret encryption"
  value       = aws_kms_key.rds_kms.key_id
}

output "autoscaling_group_name" {
  description = "Name of the Auto Scaling group"
  value       = aws_autoscaling_group.web_asg.name
}

output "region" {
  description = "AWS region in which resources are deployed"
  value       = var.region
}
