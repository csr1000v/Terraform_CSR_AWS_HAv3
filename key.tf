resource "aws_key_pair" "csrkey" {
  key_name   = var.aws_ssh_keypair_name
  public_key = base64decode("${var.base64encoded_public_ssh_key}")
}
