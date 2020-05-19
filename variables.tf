## Change outside/inside to pub/priv
variable "availability_zone" {
  description = "The AWS zone to setup your CSR1000V Highly Available Routers"
  default     = "us-west-2a"
  type        = string
}

variable "csr1000v_ami_filter" {
  description = "The filter used to search for the correct ami to use"
  default     = "cisco-CSR-.16.12.01a-AX-HVM-9f5a4516-a4c3-4cf1-89d4-105d2200230e-ami-0f6fdba70c4443b5f.4"
  type        = string
}


variable "node1_tunnel1_ip_and_mask" {
  description = "The address of the tunnel for CSRV number 1"
  default     = "192.168.101.1 255.255.255.252"
  type        = string
}

variable "node2_tunnel1_ip_and_mask" {
  description = "The address of the tunnel for CSRV number 2"
  default     = "192.168.101.2 255.255.255.252"
  type        = string
}

variable "tunnel1_subnet_ip_and_mask" {
  description = "The address of the tunnel and the subnet mask"
  default     = "192.168.101.0 0.0.0.255"
  type        = string
}

variable "base64encoded_private_ssh_key" {
  description = "base64 encoded private key to use for terraform to connect to the router"
  default     = null
  type        = string
}

variable "base64encoded_public_ssh_key" {
  description = "base64 encoded public key to use for terraform to connect to the router"
  default     = null
  type        = string
}

variable "private_vpc_cidr_block" {
  description = "Cidr block for the entire vpc"
  default     = "10.16.0.0/16"
  type        = string
}

variable "node1_eth1_private_ip" {
  description = "Private ip address of the internal network interface on Node1"
  default     = "10.16.3.252"
  type        = string
}

variable "node2_eth1_private_ip" {
  description = "Private ip address of the internal network interface on Node2"
  default     = "10.16.4.253"
  type        = string
}

variable "node1_private_subnet_cidr_block" {
  description = "Private ip cidr_block for the node1 subnet"
  default     = "10.16.3.0/24"
  type        = string
}

variable "node2_private_subnet_cidr_block" {
  description = "Private ip cidr_block for the node2 subnet"
  default     = "10.16.4.0/24"
  type        = string
}
variable "node1_public_subnet_cidr_block" {
  description = "Public ip cidr_block for the node1 subnet"
  default     = "10.16.1.0/24"
  type        = string
}

variable "node2_public_subnet_cidr_block" {
  description = "Public ip cidr_block for the node2 subnet"
  default     = "10.16.2.0/24"
  type        = string
}

variable "public_route_table_allowed_cidr" {
  description = "Allowed cidr_block for connections from the public network interface route table"
  default     = "0.0.0.0/0"
  type        = string
}

variable "public_security_group_ingress_cidr_blocks" {
  description = "Allowed cidr_block for connections to the public network"
  default     = ["0.0.0.0/0"]
  type        = list(string)
}

variable "public_security_group_egress_rules" {
  description = "Allowed cidr_block for connections from the public"
  default     = ["all-all"]
  type        = list(string)
}

variable "ssh_ingress_cidr_block" {
  description = "Address block from which ssh is allowed"
  default     = ["0.0.0.0/0"]
  type        = list(string)
}

variable "public_security_group_ingress_rules" {
  description = "Rules allowed to public network"
  default     = ["https-443-tcp", "http-80-tcp", "all-icmp"]
  type        = list(string)
}

variable "instance_type" {
  description = "Machine size of the routers"
  default     = "c4.large"
}

variable "aws_region" {
  description = "Region for aws"
  default     = "us-west-2"
}

variable "csr1000v_instance_profile" {
  default     = null
  description = "Only for using existing instance profiles to pass to the csr1000v ha module, or when using multiple instances of this module"
}

variable "aws_ssh_keypair_name" {
  default     = null
  description = "Name of ssh key pair you are putting into aws"
}
