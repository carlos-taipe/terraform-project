### Provider Configuration ###
provider "aws" {
  region = "us-east-1"
}

### Resource: EC2 Instance for Nginx Server ###
resource "aws_instance" "nginx_server" {
  ami           = "ami-0ed094fb1304fd857" # Amazon Linux 2 AMI
  instance_type = "t3.micro"

  tags = {
    Name = "Nginx Server"
  }
}