# Task 6: Data Source (Finds latest Ubuntu AMI automatically)
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# Task 5 & 8: Calling the Module with Workspace support
module "web_server" {
  source = "./modules/web_server"

  ami_id           = data.aws_ami.ubuntu.id
  instance_type    = "t3.micro"            # t3.micro is safer for new accounts
  environment      = terraform.workspace   # Task 8: Uses "dev", "prod", etc. automatically
  
  # SSH Config for Task 9
  key_name         = "my-aws-key"          # Must match Key Pair name in AWS Console
  private_key_path = "./my-aws-key.pem"    # Must match the file name on your laptop
}

# Output the IP so you can visit the website
output "website_ip" {
  value = module.web_server.public_ip
}