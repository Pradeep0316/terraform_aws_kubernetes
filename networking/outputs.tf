#-----networking/outputs.kube

output "public_subnet" {
  value = "${aws_subnet.kube_private.id}"
}

output "vpc_id" {
  value = "${aws_vpc.kube_vpc.id}"
}

output "vpc_subnet_id" {
  value = "${aws_subnet.kube_private.id}"
}


output "route_table_id" {
  value = "${aws_route_table.kube_public_rt.id}"
}
