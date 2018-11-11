resource "aws_security_group" "sg" {
  name   = "${var.name}-instance-sg"
  vpc_id = "${aws_vpc.my_vpc.id}"
}

resource "aws_security_group_rule" "inbound_ssh" {
  from_port         = 22
  protocol          = "tcp"
  security_group_id = "${aws_security_group.sg.id}"
  to_port           = 22
  type              = "ingress"
  cidr_blocks       = ["${var.ip_to_ssh_from}"]
}

resource "aws_security_group_rule" "icmp_ingress" {
  from_port         = -1
  protocol          = "icmp"
  to_port           = -1
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "ingress"
  security_group_id = "${aws_security_group.sg.id}"
}

resource "aws_security_group_rule" "outbound" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = "${aws_security_group.sg.id}"
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}
