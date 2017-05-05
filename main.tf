#
# DO NOT DELETE THESE LINES!
#
# Your AMI ID is:
#
#     ami-2df66d3b
#
# Your subnet ID is:
#
#     subnet-75a08610
#
# Your security group ID is:
#
#     sg-4cc10432
#
# Your Identity is:
#
#     testing-termite
#

terraform {
  backend "atlas" {
    name = "jeremywinters/training"
  }
}

variable "aws_access_key" {
  type = "string"
}

variable "aws_secret_key" {
  type = "string"
}

variable "aws_region" {
  default = "us-east-1"
}


provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

variable "num_webs" {
  default = "3"
}

resource "aws_instance" "web" {
  count = "${var.num_webs}"
  ami                    = "ami-2df66d3b"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-75a08610"
  vpc_security_group_ids = ["sg-4cc10432"]

  tags {
    Identity = "testing-termite"
    Chicken = "a dumb bird"
    Turkey = "not much smarter"
    Name = "${count.index + 1} / ${var.num_webs}"
  }
}

output "public_ip" {
  value = ["${aws_instance.web.*.public_ip}"]
}

output "public_dns" {
  value = ["${aws_instance.web.*.public_dns}"]
}

