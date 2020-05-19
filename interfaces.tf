resource "aws_network_interface" "csr1000v1eth1" {
  subnet_id         = aws_subnet.private1.id
  security_groups   = [module.security_group_inside.this_security_group_id]
  private_ips       = [var.node1_eth1_private_ip]
  source_dest_check = false
  attachment {
    instance     = join("", module.instance1.id)
    device_index = 1
  }
}

resource "aws_network_interface" "csr1000v2eth1" {
  subnet_id         = "${aws_subnet.private2.id}"
  private_ips       = ["${var.node2_eth1_private_ip}"]
  security_groups   = ["${module.security_group_inside.this_security_group_id}"]
  source_dest_check = false
  attachment {
    instance     = join("", "${module.instance2.id}")
    device_index = 1
  }
}
