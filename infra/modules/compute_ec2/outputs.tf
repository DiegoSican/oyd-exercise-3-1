output "instance_arn" {
  description = "ARN of EC2 instance"
  value       = aws_instance.ec2.arn
}

output "public_ip" {
  description = "Public IP of EC2 instance"
  value       = aws_instance.ec2.public_ip
}