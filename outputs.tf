output "node1_public_ip_address" {
  value = "${module.instance1.public_ip}"
}

output "node2_public_ip_address" {
  value = "${module.instance2.public_ip}"
}

output "output_script" {
  value = local.output_script
}
