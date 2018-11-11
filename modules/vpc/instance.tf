data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "${var.name}-ssh-key"
  public_key = "${var.ssh_public_key}"
}

data "template_file" "install_dd_script" {
  template = "${file("${path.module}/templates/install_dd_agent.sh")}"

  vars {
    DD_API_KEY = "${var.dd_api_token}"
  }
}

resource "aws_instance" "test" {
  count                       = "${length(data.aws_availability_zones.available.names)}"
  ami                         = "${data.aws_ami.ubuntu.id}"
  instance_type               = "t2.micro"
  subnet_id                   = "${element(aws_subnet.subnet.*.id, count.index)}"
  availability_zone           = "${element(aws_subnet.subnet.*.availability_zone, count.index)}"
  key_name                    = "${aws_key_pair.ssh_key.key_name}"
  vpc_security_group_ids      = ["${aws_security_group.sg.id}"]
  associate_public_ip_address = true

  tags {
    Name = "${var.name}-${element(aws_subnet.subnet.*.availability_zone, count.index)}-inst"
  }

  provisioner "file" {
    content     = "${data.template_file.install_dd_script.rendered}"
    destination = "/tmp/install_dd_agent.sh"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file(var.ssh_private_key_file)}"
    }
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file(var.ssh_private_key_file)}"
    }

    inline = [
      "chmod +x /tmp/install_dd_agent.sh",
      "/tmp/install_dd_agent.sh",
      "rm -f /tmp/install_dd_agent.sh",
    ]
  }

  depends_on = ["aws_internet_gateway.igw"]
}
