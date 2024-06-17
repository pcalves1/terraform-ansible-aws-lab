resource "aws_vpc" "terraform_ansible_lab" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "terraform_ansible_lab"
  }
}

resource "aws_internet_gateway" "terraform_ansible_lab_gw" {
  vpc_id = aws_vpc.terraform_ansible_lab.id
  tags = {
    Name = "terraform_ansible_lab_gw"
  }
}

resource "aws_route_table" "terraform_ansible_lab_rt" {
  vpc_id = aws_vpc.terraform_ansible_lab.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform_ansible_lab_gw.id
  }
  tags = {
    Name = "terraform_ansible_lab_rt"
  }
}

resource "aws_subnet" "lab_subnet_a" {
  vpc_id            = aws_vpc.terraform_ansible_lab.id
  cidr_block        = var.subnet_cidr_block_a
  availability_zone = "${var.aws_region}a"
  tags              = var.subnet_tags
}

resource "aws_subnet" "lab_subnet_b" {
  vpc_id            = aws_vpc.terraform_ansible_lab.id
  cidr_block        = var.subnet_cidr_block_b
  availability_zone = "${var.aws_region}b"
  tags              = var.subnet_tags
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.lab_subnet_a.id
  route_table_id = aws_route_table.terraform_ansible_lab_rt.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.lab_subnet_b.id
  route_table_id = aws_route_table.terraform_ansible_lab_rt.id
}



resource "aws_lb" "elb_todo_app" {
  name            = "todo-app-elb"
  internal        = false
  subnets         = [aws_subnet.lab_subnet_a.id, aws_subnet.lab_subnet_b.id]
  security_groups = [aws_security_group.elb_application_sg.id]
  tags = {
    "Name" = "todo-app-loadbalancer"
  }
}

resource "aws_lb" "mysql_nlb" {
  name               = "mysql-nlb"
  load_balancer_type = "network"
  internal           = true
  subnets            = [aws_subnet.lab_subnet_a.id, aws_subnet.lab_subnet_b.id]
  security_groups    = [aws_security_group.elb_mysql_sg.id]
  tags = {
    "Name" = "mysql-loadbalancer"
  }
}

resource "aws_lb_target_group" "target_todo_app" {
  name     = "todo-app-tg"
  port     = "3000"
  protocol = "HTTP"
  vpc_id   = aws_vpc.terraform_ansible_lab.id
  tags = {
    "Name" = "todo-app-target-group"
  }
}

resource "aws_lb_target_group" "target_mysql" {
  name        = "mysql-tg"
  port        = 3306
  protocol    = "TCP"
  vpc_id      = aws_vpc.terraform_ansible_lab.id
  target_type = "instance"
  tags = {
    "Name" = "mysql-target-group"
  }
}


resource "aws_lb_listener" "listener_todo_app" {
  load_balancer_arn = aws_lb.elb_todo_app.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_todo_app.arn
  }
  tags = {
    "Name" = "todo-app-listener"
  }
}

resource "aws_lb_listener" "mysql_listener" {
  load_balancer_arn = aws_lb.mysql_nlb.arn
  port              = 3306
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_mysql.arn
  }
  tags = {
    "Name" = "mysql-listener"
  }
}

output "loadb_balancers_addresses" {
  value = {
    application = aws_lb.elb_todo_app.dns_name,
    mysql       = aws_lb.mysql_nlb.dns_name
  }
}
