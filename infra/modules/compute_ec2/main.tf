resource "aws_iam_role" "ec2_role" {
  name = "${var.name}-${var.environment}-role"

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
}

resource "aws_iam_role_policy" "s3_policy" {
  name = "${var.name}-${var.environment}-policy"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "s3:GetObject"
        Effect = "Allow"
        Resource = "arn:aws:s3:::${var.app_s3_bucket}/server.rb"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "profile" {
  name = "${var.name}-${var.environment}-profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_security_group" "sg" {
  name = "${var.name}-${var.environment}-sg"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  iam_instance_profile   = aws_iam_instance_profile.profile.name
  vpc_security_group_ids = [aws_security_group.sg.id]

  tags = {
    Name = "${var.name}-${var.environment}"
  }

  user_data = <<-EOF
              #!/bin/bash
              dnf install -y ruby
              aws s3 cp s3://${var.app_s3_bucket}/server.rb /opt/server.rb
              COMPUTE_TYPE=ec2 nohup ruby /opt/server.rb &
              EOF
}