
provider "aws" {
  region = var.region
}

resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "ec2_ssm_role" {
  name = "ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_ssm_profile" {
  name = "ec2-ssm-profile"
  role = aws_iam_role.ec2_ssm_role.name
}

resource "aws_instance" "web" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  security_groups        = [aws_security_group.web_sg.id]
  user_data              = file("user_data.sh")
  iam_instance_profile   = aws_iam_instance_profile.ec2_ssm_profile.name

  tags = {
    Name = "Apache2-PHP-EC2"
  }
}

resource "aws_kms_key" "rds_kms" {
  description             = "KMS for Secrets Manager rotation"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

resource "aws_secretsmanager_secret_rotation" "rds_rotation" {
  secret_id           = aws_secretsmanager_secret.rds_secret.id
  rotation_lambda_arn = aws_lambda_function.rds_rotation_lambda.arn

  rotation_rules {
    automatically_after_days = 7
  }
}


resource "aws_db_subnet_group" "rds_subnet" {
  name       = "rds-subnet-group"
  subnet_ids = var.rds_subnet_ids

  tags = {
    Name = "RDS Subnet Group"
  }
}

resource "aws_db_instance" "rds" {
  identifier              = "myrdsdb"
  allocated_storage       = 20
  storage_type            = "gp2"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  name                    = "assignmentdb"
  username                = "admin"
  password                = "Admin@7890"
  skip_final_snapshot     = true
  publicly_accessible     = true
  vpc_security_group_ids  = [aws_security_group.web_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet.name

  tags = {
    Name = "Terraform-RDS"
  }
}
