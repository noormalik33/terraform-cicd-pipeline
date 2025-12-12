# 1. Define the Security Group (Allows SSH & HTTP)
resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh_http_${var.environment}"
  description = "Allow SSH and HTTP inbound traffic"

  # SSH access (Port 22)
  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access (Port 80 - for Nginx)
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound internet access (Required to download Nginx)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 2. Define the EC2 Instance
resource "aws_instance" "this" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  # --- THIS IS THE NEW LINE YOU NEEDED ---
  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]
  # ---------------------------------------

  tags = {
    Name        = "Web-${var.environment}"
    Environment = var.environment
  }

  lifecycle {
     # prevent_destroy = true
    ignore_changes = [tags]
  }

  # Installs Nginx
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
      "sudo systemctl start nginx"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key_path)
      host        = self.public_ip
    }
  }
}