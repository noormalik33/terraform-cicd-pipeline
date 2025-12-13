# main.tf

module "web_server" {
  source = "./modules/web_server"

  ami_id        = "ami-0030e4319cbf4dbf2" # Ubuntu 22.04 in us-east-1
  instance_type = "t2.micro"
  key_name      = "terraform-key"         # Ensure this key exists in your AWS Console
  environment   = "prod"
}

output "website_ip" {
  value = module.web_server.instance_ip
}