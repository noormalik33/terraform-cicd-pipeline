# Task 6: Data Source for Dynamic AMI Lookup
# This asks AWS: "Give me the ID of the latest Ubuntu 22.04 server"
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (Owner of Ubuntu)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh_http_${var.environment}"
  description = "Allow SSH and HTTP inbound traffic"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
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

resource "aws_instance" "this" {
  # Task 6: Use the dynamic AMI ID found above (not hardcoded!)
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]

  # Task 9: Provisioning (Install Nginx automatically)
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y nginx
              sudo systemctl start nginx
              sudo systemctl enable nginx
              echo "<h1>Hello from Terraform Pipeline!</h1>" | sudo tee /var/www/html/index.html
              EOF

  tags = {
    Name        = "Web-${var.environment}"
    Environment = var.environment
  }

  # Task 10: Lifecycle Rules
  lifecycle {
    # This setting ensures a new replacement server is created BEFORE the old one is destroyed
    create_before_destroy = true
    
    # UNCOMMENT the line below to test "Prevent Destroy" (Task 10 requirement)
    # prevent_destroy = true
  }
}