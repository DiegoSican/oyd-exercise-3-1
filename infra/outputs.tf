output "instance_arn" {
  description = "EC2 instance ARN"
  value       = module.compute_ec2.instance_arn
}

output "public_ip" {
  description = "EC2 public IP"
  value       = module.compute_ec2.public_ip
}