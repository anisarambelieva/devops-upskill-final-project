resource "aws_vpc" "ecs-vpc" {
  cidr_block = "${var.cidr}"
}

resource "aws_subnet" "subnets" {
  count                   = length(var.azs)
  vpc_id                  = "${aws_vpc.ecs-vpc.id}"
  availability_zone       = "${var.azs[count.index]}"
  cidr_block              = "${var.subnets-ip[count.index]}"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = "${aws_vpc.ecs-vpc.id}"
}