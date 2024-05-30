terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.aws_region
}

resource "aws_launch_template" "todo_app_template" {
  name          = "todo-app-template"
  image_id      = var.ami
  instance_type = var.instance
  key_name      = var.ssh_key

  user_data = base64encode(templatefile("app-starter.sh", {
    mysql_addr     = aws_lb.mysql_nlb.dns_name,
    mysql_password = var.mysql_password,
    mysql_user     = var.mysql_user
  }))

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.todo_app_sg.id]
  }

  tags = {
    "Name" = "todo-app-instance"
  }
  depends_on = [aws_lb.mysql_nlb]
}

resource "aws_autoscaling_group" "application_asg" {
  desired_capacity    = 1
  max_size            = 3
  min_size            = 1
  vpc_zone_identifier = [aws_subnet.lab_subnet_a.id, aws_subnet.lab_subnet_b.id]
  launch_template {
    id      = aws_launch_template.todo_app_template.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.target_todo_app.arn]
  tag {
    key                 = "Name"
    value               = "todo-app-instance"
    propagate_at_launch = true
  }
  depends_on = [ aws_lb.elb_todo_app ]
}

resource "aws_launch_template" "mysql_template" {
  name          = "mysql-template"
  image_id      = var.ami
  instance_type = var.instance
  key_name      = var.ssh_key

  user_data = base64encode(templatefile("mysql-starter.sh", {
    todo_app_ip    = aws_lb.elb_todo_app.dns_name,
    mysql_password = var.mysql_password,
    mysql_user     = var.mysql_user
  }))

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.mysql_sg.id]
  }

  tags = {
    "Name" = "mysql-instance"
  }

  depends_on = [aws_lb.elb_todo_app]

}

resource "aws_autoscaling_group" "mysql_asg" {
  desired_capacity    = 1
  max_size            = 3
  min_size            = 1
  vpc_zone_identifier = [aws_subnet.lab_subnet_a.id, aws_subnet.lab_subnet_b.id]
  launch_template {
    id      = aws_launch_template.mysql_template.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "mysql-instance"
    propagate_at_launch = true
  }
  target_group_arns = [aws_lb_target_group.target_mysql.arn]
}


resource "aws_key_pair" "ssh_key" {
  key_name   = var.ssh_key
  public_key = file("~/.ssh/${var.ssh_key}.pub")
}




output "load_balancers_addresses" {
  value = {
    application = aws_lb.elb_todo_app.dns_name,
  }
}
