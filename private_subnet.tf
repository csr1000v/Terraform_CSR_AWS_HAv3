resource "aws_subnet" "private1" {
  vpc_id            = "${aws_vpc.private.id}"
  availability_zone = "${var.availability_zone}"
  cidr_block        = "${var.node1_private_subnet_cidr_block}"
  tags = {
    Name = "csrv1000vprivatesubnet1"
  }
}

resource "aws_subnet" "private2" {
  vpc_id            = "${aws_vpc.private.id}"
  availability_zone = "${var.availability_zone}"
  cidr_block        = "${var.node2_private_subnet_cidr_block}"
  tags = {
    Name = "csrv1000vprivatesubnet2"
  }
}
