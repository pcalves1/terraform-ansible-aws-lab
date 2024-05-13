module "aws-dev-app" {
  source              = "../aws-base"
  ami                 = "ami-04b70fa74e45c3917"
  instance            = "t2.micro"
  aws_region          = "us-east-1"
  vpc_name            = "dev"
  security_group_name = "dev-general-access"
  availability_zone   = "us-east-1a"
  associate_public_ip = "true"
  ssh_key             = "aws-general"
}

output "IP" {
  value = module.aws-dev-app.aws-dev-app-ips
}