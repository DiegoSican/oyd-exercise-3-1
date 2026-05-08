variable "environment" {
  description = "Environment name"
  type        = string
}

variable "name" {
  description = "Application name"
  type        = string
}

variable "ami_id" {
  description = "AMI ID"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "allowed_cidr_blocks" {
  description = "Allowed CIDR blocks"
  type        = list(string)
}

variable "app_s3_bucket" {
  description = "S3 bucket containing server.rb"
  type        = string
}