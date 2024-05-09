resource "aws_vpc" "eks_lab" {
  cidr_block = "10.0.0.0/16"
  tags = {
    lab  = "eks"
    Name = "eks_lab"
  }
}

resource "aws_subnet" "eks_subnet" {
  vpc_id            = aws_vpc.eks_lab.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.availability_zone
  tags              = var.subnet_tags
}

resource "aws_internet_gateway" "eks_lab_gw" {
  vpc_id = aws_vpc.eks_lab.id
  tags = {
    Name = "eks_lab_gw"
    lab  = "eks"
  }
}

resource "aws_route_table" "eks_lab_rt" {
  vpc_id = aws_vpc.eks_lab.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks_lab_gw.id
  }
  tags = {
    Name = "eks_lab_rt"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.eks_subnet.id
  route_table_id = aws_route_table.eks_lab_rt.id
} 
