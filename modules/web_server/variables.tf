variable "ami_id" {
  description = "The AMI ID to deploy (optional, will be looked up if empty)"
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "The type of EC2 instance to launch"
  type        = string
  default     = "t2.micro"  # <--- Crucial for Free Tier
}

variable "key_name" {
  description = "Name of the AWS key pair"
  type        = string
}

variable "environment" {
  description = "Deployment environment (dev/prod)"
  type        = string
  default     = "prod"
}