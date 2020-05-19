# AWS EC2 CSR HA Terraform Module

Terraform module which creates an HA Pair of two CSR 1000V soft switches in AWS.
<br>[CSR1000v High Availability Configuration guide](https://www.cisco.com/c/en/us/td/docs/routers/csr1000/software/configuration/b_CSR1000v_Configuration_Guide/b_CSR1000v_Configuration_Guide_chapter_010111.html)

### IMPORTANT!
* This terraform module outputs a series of generated commands that require manual execution, you will have to have the ssh key you provided named csr.pem in the directory in which you run these scripts. Terraform could not run these due to the CSR ami handing the ssh session over to a telnet session.

### Requirements
* Requires Terraform version 12 or greater
* Ensure aws credentials are specified before executing terraform plan. There are multiple ways to do achieve this and documented in detail at [AWS Provider](https://www.terraform.io/docs/providers/aws/index.html)
* The examples folder has main.tf file showing sample usage of CSR AWS HAv3 module. In order to use the sample file, edit the main.tf in example folder with the correct variables
* Public and private keys are needed in order to SSH into CSR after deployment in order to apply day 0 configuration. Specify base64 encoded public and private keys in var.tfvars file. The keyfile can be encoded to base64 using openssl utility: 
  * openssl base64 -in *inputfile.pem* -out *outputfile*

## Usage

```hcl
module CSRV_HA {
  source                                    = "github.com/csr1000v/Terraform_CSR_AWS_HAv3"
  base64encoded_private_ssh_key             = "${var.base64encoded_private_ssh_key}"
  base64encoded_public_ssh_key              = "${var.base64encoded_public_ssh_key}"
  aws_region                                = "us-west-1"
  availability_zone                         = "us-west-1a"
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
  instance_type                             = "c5.large"
  csr1000v_ami_filter                       = "CSR_AMI-cppbuild.17.1.1-byol-624f5bb1-7f8e-4f7c-ad2c-03ae1cd1c2d3-ami-08547c5201dca980c.4"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| availability\_zone | The AWS zone to setup your CSR1000V Highly Available Routers | string | `"us-west-1a"` | no |
| aws\_region | Region for aws | string | `"us-west-1"` | no |
| base64encoded\_ssh\_private\_key | base64 encoded private key to use for terraform to connect to the router | string | n/a | yes |
| base64encoded\_ssh\_public\_key | base64 encoded public key to use for terraform to connect to the router | string | n/a | yes |
| aws\_ssh\_keypair\_name | Name of ssh key pair you are putting into aws | string | `<string>` | yes |
| csr1000v\_ami\_filter | Filter to find best match of image | string | `"CSR_AMI-cppbuild.17.1.1-byol-624f5bb1-7f8e-4f7c-ad2c-03ae1cd1c2d3-ami-08547c5201dca980c.4"` | no |
| csr1000v\_instance\_profile | Only for using existing instance profiles to pass to the csr1000v ha module, or when using multiple instances of this module | string | n/a | no |
| instance\_type | Machine size of the routers | string | `"c5.large"` | no |
| node1\_eth1\_private\_ip | Private ip address of the internal network interface on Node1 | string | `"10.16.3.252"` | no |
| node1\_private\_subnet\_cidr\_block | Private ip cidr\_block for the node1 subnet | string | `"10.16.3.0/24"` | no |
| node1\_public\_subnet\_cidr\_block | Public ip cidr\_block for the node1 subnet | string | `"10.16.1.0/24"` | no |
| node1\_tunnel1\_ip\_and\_mask | The address of the tunnel for CSRV number 1 | string | `"192.168.101.1 255.255.255.252"` | no |
| node2\_eth1\_private\_ip | Private ip address of the internal network interface on Node2 | string | `"10.16.4.253"` | no |
| node2\_private\_subnet\_cidr\_block | Private ip cidr\_block for the node2 subnet | string | `"10.16.4.0/24"` | no |
| node2\_public\_subnet\_cidr\_block | Public ip cidr\_block for the node2 subnet | string | `"10.16.2.0/24"` | no |
| node2\_tunnel1\_ip\_and\_mask | The address of the tunnel for CSRV number 2 | string | `"192.168.101.2 255.255.255.252"` | no |
| private\_vpc\_cidr\_block | Cidr block for the entire vpc | string | `"10.16.0.0/16"` | no |
| public\_route\_table\_allowed\_cidr | Allowed cidr\_block for connections from the public network interface route table | string | `"0.0.0.0/0"` | no |
| public\_security\_group\_egress\_rules | Allowed cidr\_block for connections from the public | list(string) | `<list>` | no |
| public\_security\_group\_egress\_rules | Allowed cidr\_block for connections from the public | list(string) | `<list>` | no |
| public\_security\_group\_ingress\_cidr\_blocks | Allowed cidr\_block for connections to the public network | list(string) | `<list>` | no |
| public\_security\_group\_ingress\_rules | Rules allowed to public network | list(string) | `<list>` | no |
| ssh\_ingress\_cidr\_block | Address block from which ssh is allowed | list(string) | `<list>` | no |
| tunnel1\_subnet\_ip\_and\_mask | The address of the tunnel and the subnet mask | string | `"192.168.101.0 0.0.0.255"` | no |


## Outputs

| Name | Description |
|------|-------------|
| node1\_public\_ip\_address |  |
| node2\_public\_ip\_address |  |
| csr1000v\_instance\_profile |  |


## Extra
To see the relationship map open graph.svg in a browser

## Authors

Module managed by [IGNW](https://github.com/ignw).

## License

kpache 2 Licensed. See LICENSE for full details.
