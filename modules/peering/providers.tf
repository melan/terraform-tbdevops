provider "aws" {
  alias  = "main"
  region = "${var.main_region}"
}

provider "aws" {
  alias  = "peer"
  region = "${var.peer_region}"
}
