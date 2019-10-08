resource "aws_security_group" "k8s_security_group" {
  vpc_id = "${var.vpc_id}"
  name = "${var.security_grp_name}"
  description = "security group that allows ssh and all egress traffic"

  tags = {
    Name = "kubernetes"
  }
}
resource "aws_security_group_rule" "allow_all" {
    type = "ingress"
    from_port = 0
    to_port = 65535
    protocol = "-1"
    security_group_id = "${aws_security_group.k8s_security_group.id}"
    cidr_blocks = ["10.240.0.0/24","10.200.0.0/16"]
}

resource "aws_security_group_rule" "allow_ssh" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_group_id = "${aws_security_group.k8s_security_group.id}"
    cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_some_kubernetes_access" {
    type = "ingress"
    from_port = 6443
    to_port = 6443
    protocol = "tcp"
    security_group_id = "${aws_security_group.k8s_security_group.id}"
    cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_access_from_this_security_group" {
    type = "ingress"
    from_port = 0
    to_port = 65535
    protocol = "-1"
    security_group_id = "${aws_security_group.k8s_security_group.id}"
    source_security_group_id = "${aws_security_group.k8s_security_group.id}"
}

resource "aws_security_group_rule" "allow_all_outgoing_traffic" {
    type = "egress"
    from_port = 0
    to_port = 65535
    protocol = "-1"
    security_group_id = "${aws_security_group.k8s_security_group.id}"
    cidr_blocks = ["0.0.0.0/0"]
}
