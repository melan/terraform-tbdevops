provider "aws" {
  alias  = "east"
  region = "${local.east_region}"
}

provider "aws" {
  alias  = "west"
  region = "${local.west_region}"
}
