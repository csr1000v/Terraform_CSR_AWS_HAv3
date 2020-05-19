resource "aws_subnet" "public1" {
  vpc_id                  = "${aws_vpc.private.id}"
  availability_zone       = "${var.availability_zone}"
  cidr_block              = "${var.node1_public_subnet_cidr_block}"
  map_public_ip_on_launch = true
  tags = {
    Name = "csrv1000vpublicsubnet1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id                  = "${aws_vpc.private.id}"
  availability_zone       = "${var.availability_zone}"
  cidr_block              = "${var.node2_public_subnet_cidr_block}"
  map_public_ip_on_launch = true
  tags = {
    Name = "csrv1000vpublicsubnet2"
  }
}
