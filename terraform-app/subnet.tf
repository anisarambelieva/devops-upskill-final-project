resource "aws_route_table" "route-table" {
  vpc_id = aws_vpc.ecs-vpc.id
}

resource "aws_route" "route" {
  route_table_id         = aws_route_table.route-table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet-gateway.id
}

resource "aws_route_table_association" "table-association" {
  count          = length(var.azs)
  route_table_id = aws_route_table.route-table.id
  subnet_id      = aws_subnet.subnets[count.index].id
}

resource "aws_security_group" "security-group-1" {
  name        = "security-group-server"
  description = "Port 5000"
  vpc_id      = aws_vpc.ecs-vpc.id

  ingress {
    description      = "Allow Port 5000"
    from_port        = var.container_port
    to_port          = var.container_port
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    description = "Allow all ip and ports outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "security-group-2" {
  name        = "security-group-alb"
  description = "Port 80"
  vpc_id      = aws_vpc.ecs-vpc.id

  ingress {
    description      = "Allow Port 80"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    description = "Allow all ip and ports outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}