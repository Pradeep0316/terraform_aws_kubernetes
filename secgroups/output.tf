output "k8s_security_grp_id" {
  value = "${aws_security_group.k8s_security_group.id}"
}
