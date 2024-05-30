module "aws-dev-app" {
  source                    = "../aws-base"
  ami                       = "ami-04b70fa74e45c3917"
  instance                  = "t2.micro"
  aws_region                = "us-east-1"
  availability_zone_a       = "us-east-1a"
  availability_zone_b       = "us-east-1b"
  associate_public_ip       = "true"
  ssh_key                   = "aws-iac-lab" 
  mysql_password            = var.mysql_password
  mysql_user                = var.mysql_user
}

output "lb_addresses" {
  value = module.aws-dev-app.load_balancers_addresses
}