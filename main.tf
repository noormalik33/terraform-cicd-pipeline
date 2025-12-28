terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket         = "au-tf-state-noor-2025" 
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
}

# 1. Get the latest Ubuntu Image
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# 2. Create Security Group
resource "aws_security_group" "direct_sg" {
  name        = "allow_web_traffic_direct"
  description = "Allow SSH and HTTP"

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

# 3. Create Server (Hardcoded t2.micro)
resource "aws_instance" "web_server_direct" {
  ami                    = data.aws_ami.ubuntu.id
  
  # --- CRITICAL SETTING ---
  instance_type          = "t2.micro" 
  # ------------------------
  
  key_name               = "final-key"     
  vpc_security_group_ids = [aws_security_group.direct_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y nginx
              sudo systemctl start nginx
              sudo systemctl enable nginx
              echo "<h1>Direct Deployment Success!</h1>" | sudo tee /var/www/html/index.html
              EOF

  tags = {
    Name = "Direct-Web-Server"
  }
  
  lifecycle {
    create_before_destroy = true
  }
}

output "direct_ip" {
  value = aws_instance.web_server_direct.public_ip
}