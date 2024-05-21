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
  availability_zone = var.availability_zone_a
  tags              = var.subnet_tags
}

resource "aws_subnet" "lab_subnet_b" {
  vpc_id            = aws_vpc.terraform_ansible_lab.id
  cidr_block        = var.subnet_cidr_block_b
  availability_zone = var.availability_zone_b
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
  internal        = false
  subnets         = [aws_subnet.lab_subnet_a.id, aws_subnet.lab_subnet_b.id]
  security_groups = [aws_security_group.elb_general_access.id]
  tags = {
    "Name" = "todo-app-loadbalancer"
  }
}

resource "aws_lb_target_group" "target_todo_app" {
  name     = "todo-app"
  port     = "3000"
  protocol = "HTTP"
  vpc_id   = aws_vpc.terraform_ansible_lab.id
  tags = {
    "Name" = "todo-app-target-group"
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

resource "aws_lb_target_group_attachment" "target_group_attachment" {
  target_group_arn = aws_lb_target_group.target_todo_app.arn
  target_id        = aws_instance.todo_app_instance[0].id # CRIAR FORMA DE ESPECIFICAR MELHOR A INSTÂNCIA DEV-APP (IF TAG NAME EQUAL DEV-APP??)
}

output "elb_dest" {
  value = aws_lb.elb_todo_app.dns_name
}

# CONFIGURAR GRUPO DE SEGURANÇA LOADBALANCER PARA RECEBER HTTP
# CONFIGURAR GRUPO DE SEGURANÇA APP PARA RECEBER NA PORTA 3000 TUDO DO LOADBALANCER
# CONFIGURAR AUTOSCALING
# CONFIGURAR EC2 LAUNCH TEMPLATE
