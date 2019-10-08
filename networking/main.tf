
resource "aws_vpc" "kube_vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags  = {
    Name = "kubernetes-the-hard-way"
  }
}

resource "aws_subnet" "kube_private" {
  vpc_id                  = "${aws_vpc.kube_vpc.id}"
  cidr_block              = "${var.subnet_cidr}"

  tags = {
    Name = "kubernetes"
  }
}

resource "aws_internet_gateway" "kube_internet_gateway" {
  vpc_id = "${aws_vpc.kube_vpc.id}"

  tags = {
    Name = "kubernetes"
  }
}

resource "aws_route_table" "kube_public_rt" {
  vpc_id = "${aws_vpc.kube_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.kube_internet_gateway.id}"
  }

  tags = {
    Name = "kubernetes"
  }
}

resource "aws_route" "route" {
  route_table_id            = "${aws_route_table.kube_public_rt.id}"
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.kube_internet_gateway.id}"
  depends_on                = ["aws_route_table.kube_public_rt"]
}


resource "aws_route_table_association" "kube_public_assoc" {
  subnet_id      = "${aws_subnet.kube_private.id}"
  route_table_id = "${aws_route_table.kube_public_rt.id}"
}
