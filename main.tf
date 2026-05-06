### Provider Configuration ###
provider "aws" {
  region = "us-east-1"
}

### Resource: EC2 Instance for Nginx Server ###
resource "aws_instance" "nginx_server" {
    ami           = "ami-0ed094fb1304fd857" # Amazon Linux 2 AMI
    instance_type = "t3.micro"

    associate_public_ip_address = true 

    user_data = <<-EOF
                #!/bin/bash
                sudo yum install -y nginx
                sudo systemctl enable nginx
                sudo systemctl start nginx
            EOF
    
    key_name = aws_key_pair.nginx-server-ssh.key_name

    vpc_security_group_ids = [aws_security_group.nginx-server-sg.id]
    
    tags = {
        Name = "Nginx Server"
    }
}

resource "aws_security_group" "nginx-server-sg" {
    name        = "nginx-server-sg"
    description = "Allow HTTP and SSH traffic to Nginx server"

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        }
    ingress {
        from_port   = 22
        to_port     = 22
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

resource "aws_key_pair" "nginx-server-ssh" {
    key_name   = "nginx-server-ssh"
    public_key = file("nginx-server.key.pub")
}

output "public_ip" {
  value = aws_instance.nginx_server.public_ip
}