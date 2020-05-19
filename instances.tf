module instance1 {
  source        = "terraform-aws-modules/ec2-instance/aws"
  version       = "~> 2.0"
  ami           = "${data.aws_ami.csr1000v.id}"
  instance_type = var.instance_type
  subnet_id     = "${aws_subnet.public1.id}"
  name          = "csr1000v1"
  key_name      = aws_key_pair.csrkey.key_name
  #iam_instance_profile        = "${aws_iam_instance_profile.csr1000v.name}"
  iam_instance_profile        = "${var.csr1000v_instance_profile != "" ? var.csr1000v_instance_profile : aws_iam_instance_profile.csr1000v[0].name}"
  associate_public_ip_address = true
  vpc_security_group_ids      = ["${module.security_group_outside.this_security_group_id}", "${module.ssh_security_group.this_security_group_id}"]
}

module instance2 {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "~> 2.0"
  associate_public_ip_address = true
  ami                         = "${data.aws_ami.csr1000v.id}"
  name                        = "csr1000v2"
  key_name                    = aws_key_pair.csrkey.key_name
  instance_type               = var.instance_type
  iam_instance_profile        = "${var.csr1000v_instance_profile != "" ? var.csr1000v_instance_profile : aws_iam_instance_profile.csr1000v[0].name}"
  subnet_id                   = aws_subnet.public2.id
  vpc_security_group_ids      = ["${module.security_group_outside.this_security_group_id}", "${module.ssh_security_group.this_security_group_id}"]
}

data "aws_ami" "csr1000v" {
  most_recent = true

  filter {
    name   = "name"
    values = ["${var.csr1000v_ami_filter}"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["679593333241"] # Cisco

}
