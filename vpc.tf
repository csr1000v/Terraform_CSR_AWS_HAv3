resource "aws_vpc" "private" {
  cidr_block = "${var.private_vpc_cidr_block}"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.private.id}"
}
