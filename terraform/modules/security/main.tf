# 1. Application Load Balancer Security Group
resource "aws_security_group" "alb" {
  name        = "${var.environment}-alb-sg"
  description = "Control public inbound traffic to the ALB"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP from Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS from Internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-alb-sg"
    Environment = var.environment
  }
}

# 2. App Tier Security Group (Restricted to ALB only)
resource "aws_security_group" "app" {
  name        = "${var.environment}-app-sg"
  description = "Allow traffic exclusively from the ALB"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow traffic only from ALB security group"
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    description = "Allow all outbound traffic for updates and patches"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-app-sg"
    Environment = var.environment
  }
}

# 3. Least-Privilege IAM Role for App Instances (SSM Access)
resource "aws_iam_role" "app_instance_role" {
  name = "${var.environment}-app-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "${var.environment}-app-instance-role"
    Environment = var.environment
  }
}

# Attach AWS Systems Manager policy (Secure console access without open Port 22)
resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.app_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Instance Profile to attach to compute resources
resource "aws_iam_instance_profile" "app_profile" {
  name = "${var.environment}-app-instance-profile"
  role = aws_iam_role.app_instance_role.name
}
