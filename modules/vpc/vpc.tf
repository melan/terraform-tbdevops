locals {
  vpc_name = "${var.name}-vpc"
  vpc_tags = "${merge(var.tags, map("Name", local.vpc_name))}"
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "${var.cidr_block}"
  tags       = "${local.vpc_tags}"
}

resource "aws_subnet" "subnet" {
  count             = "${length(data.aws_availability_zones.available.names)}"
  cidr_block        = "${cidrsubnet(aws_vpc.my_vpc.cidr_block, 8, count.index)}"
  vpc_id            = "${aws_vpc.my_vpc.id}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"

  tags {
    Name = "${var.name}-${data.aws_availability_zones.available.names[count.index]}-subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.my_vpc.id}"

  tags {
    Name = "${var.name}-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.my_vpc.id}"

  tags {
    Name = "${var.name}-rt"
  }
}

resource "aws_route" "igw-route" {
  route_table_id         = "${aws_route_table.public.id}"
  gateway_id             = "${aws_internet_gateway.igw.id}"
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public" {
  count          = "${aws_subnet.subnet.count}"
  route_table_id = "${aws_route_table.public.id}"
  subnet_id      = "${element(aws_subnet.subnet.*.id, count.index)}"
}
