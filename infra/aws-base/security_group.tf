resource "aws_security_group" "app_general_access" {
  name        = var.app_security_group_name
  description = var.app_security_group_name

  vpc_id = aws_vpc.terraform_ansible_lab.id

  ingress {
    cidr_blocks     = ["0.0.0.0/0"]
    from_port       = 0
    to_port         = 0
    protocol        = -1
    security_groups = [aws_security_group.elb_general_access.id]
  }

  egress {
    cidr_blocks     = ["0.0.0.0/0"]
    from_port       = 0
    to_port         = 0
    protocol        = -1
    security_groups = [aws_security_group.elb_general_access.id]
  }
  tags = {
    Name = var.app_security_group_name
  }
}



resource "aws_security_group" "elb_general_access" {
  name        = var.elb_security_group_name
  description = var.elb_security_group_name

  vpc_id = aws_vpc.terraform_ansible_lab.id

  ingress {
    cidr_blocks      = ["0.0.0.0/0"]
    from_port        = 0
    to_port          = 0
    protocol         = -1
  }

  egress {
    cidr_blocks      = ["0.0.0.0/0"]
    from_port        = 0
    to_port          = 0
    protocol         = -1
  }

  tags = {
    Name = var.elb_security_group_name
  }
}