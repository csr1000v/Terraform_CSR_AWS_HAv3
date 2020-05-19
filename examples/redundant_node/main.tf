module CSRV_HA {
  source                                    = "github.com/IGNW/cisco-csr-ha-iac"
  base64encoded_private_ssh_key             = "${var.base64encoded_private_ssh_key}"
  base64encoded_public_ssh_key              = "${var.base64encoded_public_ssh_key}"
  availability_zone                         = "us-west-2a"
  node1_tunnel1_ip_and_mask                 = "192.168.101.1 255.255.255.252"
  node2_tunnel1_ip_and_mask                 = "192.168.101.2 255.255.255.252"
  tunnel1_subnet_ip_and_mask                = "192.168.101.0 0.0.0.255"
  private_vpc_cidr_block                    = "10.16.0.0/16"
  node1_eth1_private_ip                     = "10.16.3.252"
  node2_eth1_private_ip                     = "10.16.4.253"
  node1_private_subnet_cidr_block           = "10.16.3.0/24"
  node2_private_subnet_cidr_block           = "10.16.4.0/24"
  node1_public_subnet_cidr_block            = "10.16.1.0/24"
  node2_public_subnet_cidr_block            = "10.16.2.0/24"
  public_route_table_allowed_cidr           = "0.0.0.0/0"
  public_security_group_ingress_cidr_blocks = ["0.0.0.0/0"]
  public_security_group_egress_rules        = ["all-all"]
  ssh_ingress_cidr_block                    = ["0.0.0.0/0"]
  public_security_group_ingress_rules       = ["https-443-tcp", "http-80-tcp", "all-icmp"]
  instance_type                             = "t2.nano"
}


output "output_script" {
  value = module.CSRV_HA.output_script
}
