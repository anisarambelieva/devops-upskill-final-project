# data "aws_availability_zones" "available" {}

# # PUBLIC

# resource "aws_subnet" "public" {
#   count                   = var.az_count
#   cidr_block              = cidrsubnet(var.vpc_cidr_block, 8, var.az_count + count.index)
#   availability_zone       = data.aws_availability_zones.available.names[count.index]
#   vpc_id                  = aws_vpc.default.id
#   map_public_ip_on_launch = true
# }

# resource "aws_route_table" "public" {
#   vpc_id = aws_vpc.default.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.default.id
#   }
# }

# resource "aws_route_table_association" "public" {
#   count          = var.az_count
#   subnet_id      = aws_subnet.public[count.index].id
#   route_table_id = aws_route_table.public.id
# }

# resource "aws_main_route_table_association" "public_main" {
#   vpc_id         = aws_vpc.default.id
#   route_table_id = aws_route_table.public.id
# }

# # PRIVATE
 
# resource "aws_subnet" "private" {
#   count             = var.az_count
#   cidr_block        = cidrsubnet(var.vpc_cidr_block, 8, count.index)
#   availability_zone = data.aws_availability_zones.available.names[count.index]
#   vpc_id            = aws_vpc.default.id
# }

# resource "aws_route_table" "private" {
#   count  = var.az_count
#   vpc_id = aws_vpc.default.id

#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.nat_gateway[count.index].id
#   }
# }

# resource "aws_eip" "nat_gateway" {
#   count = var.az_count
#   vpc   = true
# }

# resource "aws_nat_gateway" "nat_gateway" {
#   count         = var.az_count
#   subnet_id     = aws_subnet.public[count.index].id
#   allocation_id = aws_eip.nat_gateway[count.index].id
# }

# resource "aws_route_table_association" "private" {
#   count          = var.az_count
#   subnet_id      = aws_subnet.private[count.index].id
#   route_table_id = aws_route_table.private[count.index].id
# }

# TEST NEW SETUP

# TABLE FOR PUBLIC SUBNETS
resource "aws_route_table" "pub-table" {
  vpc_id = "${aws_vpc.ecs-vpc.id}"
}

resource "aws_route" "pub-route" {
  route_table_id         = "${aws_route_table.pub-table.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.i-gateway.id}"
}

resource "aws_route_table_association" "as-pub" {
  count          = length(var.azs)
  route_table_id = "${aws_route_table.pub-table.id}"
  subnet_id      = "${aws_subnet.pub-subnets[count.index].id}"
}

resource "aws_security_group" "sg1" {
  name        = "golang-server"
  description = "Port 5000"
  vpc_id      = aws_vpc.ecs-vpc.id

  ingress {
    description      = "Allow Port 5000"
    from_port        = 5000
    to_port          = 5000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    description = "Allow all ip and ports outboun"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sg2" {
  name        = "golang-server-alb"
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
    description = "Allow all ip and ports outboun"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}