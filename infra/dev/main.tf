module "aws-dev-app" {
  source                  = "../aws-base"
  ami                     = "ami-04b70fa74e45c3917"
  instance                = "t2.micro" 
  aws_region              = "us-east-1"
  vpc_name                = "dev"
  app_security_group_name = "app-sg" 
  elb_security_group_name = "elb-sg"
  availability_zone_a     = "us-east-1a"
  associate_public_ip     = "true"
  ssh_key                 = "aws-iac-lab"
  availability_zone_b     = "us-east-1b"
}

output "IP" {
  value = module.aws-dev-app.aws-dev-app-ips
}

output "loadb_balancer_address" {
  value = module.aws-dev-app.loadb_balancer_address
}