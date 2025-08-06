provider "aws" {
  region = "us-east-1"  #  preferred region
}

resource "aws_instance" "nginx_server" {
  ami           = "ami-08a6efd148b1f7504"  # Amazon Linux 2 AMI (for us-east-1)
  instance_type = "t3.micro"

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo amazon-linux-extras install nginx1 -y
              sudo systemctl start nginx
              sudo systemctl enable nginx
              EOF

  tags = {
    Name = "Terraform-NGINX"
  }

  security_groups = [aws_security_group.nginx_sg.name]
}

resource "aws_security_group" "nginx_sg" {
  name        = "nginx_sg"
  description = "Allow HTTP traffic"

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
