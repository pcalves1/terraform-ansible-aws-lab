resource "aws_security_group" "eks_general_access" {
  name = var.security_group_name
  description = var.security_group_name

  vpc_id = aws_vpc.eks_lab.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = [ "::/0"]
    from_port = 0
    to_port = 0
    protocol = -1
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = [ "::/0"]
    from_port = 0
    to_port = 0
    protocol = -1
  }
  
  tags = {
    name = var.security_group_name
    lab = "eks"
  }
}