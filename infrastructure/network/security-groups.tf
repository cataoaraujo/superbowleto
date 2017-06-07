resource "aws_security_group" "dmz" {
  name_prefix = "${lower(var.vpc_name)}_"
  description = "${var.vpc_name} DMZ Security Group"
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "${var.vpc_name} DMZ Security Group"
  }
}

resource "aws_security_group" "lambda" {
  name_prefix = "${lower(var.vpc_name)}_"
  description = "${var.vpc_name} Lambda Security Group"
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name = "${var.vpc_name} Lambda Security Group"
  }
}

resource "aws_security_group" "database" {
  name_prefix = "${lower(var.vpc_name)}_"
  description = "${var.vpc_name} Database Security Group"
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "${var.vpc_name} Database Security Group"
  }
}

resource "aws_security_group_rule" "dmz-from-all-1" {
  security_group_id = "${aws_security_group.dmz.id}"
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "dmz-from-all-2" {
  security_group_id = "${aws_security_group.dmz.id}"
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "dmz-to-lambda-1" {
  security_group_id = "${aws_security_group.dmz.id}"
  type = "egress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  source_security_group_id = "${aws_security_group.lambda.id}"
}

resource "aws_security_group_rule" "dmz-to-lambda-2" {
  security_group_id = "${aws_security_group.dmz.id}"
  type = "egress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  source_security_group_id = "${aws_security_group.lambda.id}"
}

resource "aws_security_group_rule" "lambda-from-dmz-1" {
  security_group_id = "${aws_security_group.lambda.id}"
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  source_security_group_id = "${aws_security_group.dmz.id}"
}

resource "aws_security_group_rule" "lambda-from-dmz-2" {
  security_group_id = "${aws_security_group.lambda.id}"
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  source_security_group_id = "${aws_security_group.dmz.id}"
}

resource "aws_security_group_rule" "lambda-to-database-1" {
  security_group_id = "${aws_security_group.lambda.id}"
  type = "egress"
  from_port = 5432
  to_port = 5432
  protocol = "tcp"
  source_security_group_id = "${aws_security_group.database.id}"
}

resource "aws_security_group_rule" "database-from-lambda-1" {
  security_group_id = "${aws_security_group.database.id}"
  type = "ingress"
  from_port = 5432
  to_port = 5432
  protocol = "tcp"
  source_security_group_id = "${aws_security_group.lambda.id}"
}