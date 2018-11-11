data "aws_caller_identity" "main" {
  provider = "aws.main"
}

data "aws_caller_identity" "peer" {
  provider = "aws.peer"
}

resource "aws_vpc_peering_connection" "requester" {
  provider = "aws.main"

  vpc_id        = "${var.main_vpc_id}"
  peer_vpc_id   = "${var.peer_vpc_id}"
  peer_owner_id = "${data.aws_caller_identity.peer.account_id}"
  peer_region   = "${var.peer_region}"
  auto_accept   = false

  tags {
    Name = "East-West VPC Peering"
    Side = "Requester"
  }
}

resource "aws_vpc_peering_connection_accepter" "peer" {
  provider = "aws.peer"

  vpc_peering_connection_id = "${aws_vpc_peering_connection.requester.id}"
  auto_accept               = true

  tags {
    Name = "East-West VPC Peering"
    Side = "Accepter"
  }
}

// Set routes
// main to peer
resource "aws_route" "main_to_peer" {
  provider                  = "aws.main"
  route_table_id            = "${var.main_route_table_id}"
  destination_cidr_block    = "${var.peer_cidr}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.requester.id}"
}

// peer to main
resource "aws_route" "peer_to_main" {
  provider                  = "aws.peer"
  route_table_id            = "${var.peer_route_table_id}"
  destination_cidr_block    = "${var.main_cidr}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.requester.id}"
}
