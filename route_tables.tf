resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.private.id}"

  route {
    cidr_block = "${var.public_route_table_allowed_cidr}"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags = {
    Name = "csrv1000vpublic"
  }
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.private.id}"
  tags = {
    Name = "csrv1000vprivate"
  }
}

resource "aws_route_table_association" "public1" {
  subnet_id      = "${aws_subnet.public1.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "public2" {
  subnet_id      = "${aws_subnet.public2.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "private1" {
  subnet_id      = "${aws_subnet.private1.id}"
  route_table_id = "${aws_route_table.private.id}"
}

resource "aws_route_table_association" "private2" {
  subnet_id      = "${aws_subnet.private1.id}"
  route_table_id = "${aws_route_table.private.id}"
}
