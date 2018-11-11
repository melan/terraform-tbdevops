output "vpc_id" {
  value = "${aws_vpc.my_vpc.id}"
}

output "route_table_id" {
  value = "${aws_route_table.public.id}"
}
