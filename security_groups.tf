module "security_group_outside" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name        = "csroutside"
  description = "Security group for public interface of csr1000v"
  vpc_id      = "${aws_vpc.private.id}"

  ingress_cidr_blocks = "${var.public_security_group_ingress_cidr_blocks}"
  ingress_rules       = "${var.public_security_group_ingress_rules}"
  egress_rules        = "${var.public_security_group_egress_rules}"
}

module "ssh_security_group" {
  source              = "terraform-aws-modules/security-group/aws//modules/ssh"
  version             = "~> 3.0"
  name                = "csrssh"
  vpc_id              = "${aws_vpc.private.id}"
  ingress_cidr_blocks = "${var.ssh_ingress_cidr_block}"
}

module "security_group_inside" {
  source              = "terraform-aws-modules/security-group/aws"
  version             = "~> 3.0"
  name                = "csrinside"
  description         = "Security group for private interface of csr1000v"
  vpc_id              = "${aws_vpc.private.id}"
  ingress_cidr_blocks = ["${aws_vpc.private.cidr_block}"]
  ingress_rules       = ["all-all"]
  egress_rules        = ["all-all"]
}

module "security_group_failover" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name        = "csrfailover"
  description = "Security group for private interface of csr1000v"
  vpc_id      = "${aws_vpc.private.id}"

  ingress_cidr_blocks = ["${aws_vpc.private.cidr_block}"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 4789
      to_port     = 4789
      protocol    = "udp"
      description = "Failover udp check between routers"
      cidr_blocks = "${aws_vpc.private.cidr_block}"
    },
    {
      from_port   = 4790
      to_port     = 4790
      protocol    = "udp"
      description = "Failover udp check between routers"
      cidr_blocks = "${aws_vpc.private.cidr_block}"
    },
  ]
  egress_rules = ["all-all"]
}
