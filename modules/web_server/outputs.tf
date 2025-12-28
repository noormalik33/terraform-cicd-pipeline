# modules/web_server/outputs.tf

output "instance_ip" {
  value = aws_instance.this.public_ip
}