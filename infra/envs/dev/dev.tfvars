environment = "dev"

name = "ruby-server"

ami_id = "ami-0d43f0bb92e485897"

instance_type = "t3.micro"

allowed_cidr_blocks = [
  "190.149.42.187/32"
]

app_s3_bucket = "diego-ejercicio-3-1"