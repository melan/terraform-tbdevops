variable "my_ip" {
  description = "Public IP of the computer to whitelist it for incoming SSH connection"
  type        = "string"
}

variable "ssh_public_key" {
  description = "SSH public key to use it for SSH access to newly created instances"
  type        = "string"
}
