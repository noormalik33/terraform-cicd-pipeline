# modules/web_server/variables.tf

variable "ami_id" {
  description = "AMI ID to launch"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "AWS Key Pair Name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

# ✅ Removed variable "private_key_path" completely
