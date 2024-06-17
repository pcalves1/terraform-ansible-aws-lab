resource "aws_security_group" "todo_app_sg" {
  name        = "todo-app-sg"
  description = "Application instance group"

  vpc_id = aws_vpc.terraform_ansible_lab.id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.mysql_sg.id]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["179.191.215.224/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "todo-app-sg"
  }
  # depends_on = [aws_security_group.elb_mysql_sg, aws_security_group.elb_application_sg]
}

resource "aws_security_group" "mysql_sg" {
  name        = "mysql-sg"
  description = "MySQL instance group"

  vpc_id = aws_vpc.terraform_ansible_lab.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.2.0/24"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["179.191.215.224/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mysql-sg"
  }
}


resource "aws_security_group" "elb_application_sg" {
  name        = "elb-application-sg"
  description = "Application Load balancer group"

  vpc_id = aws_vpc.terraform_ansible_lab.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "elb-application-sg"
  }
}



resource "aws_security_group" "elb_mysql_sg" {
  name        = "mysql-loadbalancer-sg"
  description = "MySQL Load balancer group"

  vpc_id = aws_vpc.terraform_ansible_lab.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.2.0/24"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "elb-mysql-sg"
  }
}

