variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
  description = "AMI ID for EC2"
  type        = string
  default     = "ami-08a6efd148b1f7504"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "EC2 Key Pair"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for EC2"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for security group"
  type        = string
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "assignmentdb"
}

variable "db_username" {
  description = "RDS username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "RDS password"
  type        = string
  sensitive   = true
  default     = "Admin@7890"
}

variable "rds_subnet_ids" {
  description = "List of Subnet IDs for RDS"
  type        = list(string)
}

variable "alb_subnet_ids" {
  description = "List of subnet IDs for the ALB"
  type        = list(string)
}

variable "alb_target_group_name" {
  description = "Name for the Target Group"
  type        = string
  default     = "web-target-group"
}

variable "min_size" {
  description = "Minimum number of EC2 instances"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of EC2 instances"
  type        = number
  default     = 2
}

variable "desired_capacity" {
  description = "Desired number of EC2 instances"
  type        = number
  default     = 1
}

variable "launch_template_version" {
  description = "Launch Template Version"
  type        = string
  default     = "$Latest"
}

variable "cloudfront_origin_domain" {
  description = "Origin domain name for CloudFront (e.g., ALB DNS)"
  type        = string
}
