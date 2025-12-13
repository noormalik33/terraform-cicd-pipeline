# modules/web_server/main.tf

# EC2 Instance Resource
resource "aws_instance" "this" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]

  tags = {
    Name        = "Web-${var.environment}"
    Environment = var.environment
  }

  # ✅ User data replaces remote-exec for CI/CD safe provisioning
  user_data = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y nginx
    systemctl start nginx
  EOF
}

# Optional: Output public IP of this instance
output "public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.this.public_ip
}
