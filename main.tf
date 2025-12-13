module "web_server" {
  source = "./modules/web_server"

  # ami_id = "..."       <-- REMOVE THIS LINE
  instance_type = "t3.micro"
  key_name      = "final-key"
  environment   = "prod"
}

output "website_ip" {
  value = module.web_server.instance_ip
}