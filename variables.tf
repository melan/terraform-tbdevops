variable "my_ip" {
  description = "Public IP of the computer to whitelist it for incoming SSH connection"
  type        = "string"
}

variable "ssh_public_key" {
  description = "SSH public key to use it for SSH access to newly created instances"
  type        = "string"
}

variable "ssh_private_key_file" {
  description = "Path to SSH private key"
  type        = "string"
}

variable "dd_api_key" {
  description = "DataDog API Key"
  type        = "string"
}

variable "dd_app_key" {
  description = "DataDog APP Key"
  type        = "string"
}
