provider "aws" {
  region = "us-east-2"
}


data "aws_availability_zones" "all" {}

resource "aws_autoscaling_group" "harman" {
  launch_configuration = "${aws_launch_configuration.harman.id}"
  availability_zones = ["${data.aws_availability_zones.all.names}"]

  min_size = 2
  max_size = 6

  load_balancers = ["${aws_elb.harman.name}"]
  health_check_type = "ELB"

  tag {
    key = "Name"
    value = "terraform-asg-harman"
    propagate_at_launch = true
  }
}


resource "aws_launch_configuration" "harman" {
  image_id = "ami-0de0238012031fbe9"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.instance.id}"]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF

  }


resource "aws_security_group" "instance" {
  name = "terraform-harman-instance"

  ingress {
    from_port = "${var.server_port}"
    to_port = "${var.server_port}"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_elb" "harman" {
  name = "terraform-asg-harman"
  security_groups = ["${aws_security_group.elb.id}"]
  availability_zones = ["${data.aws_availability_zones.all.names}"]

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:${var.server_port}/"
  }

  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "${var.server_port}"
    instance_protocol = "http"
  }
}


resource "aws_security_group" "elb" {
  name = "terraform-harman-elb"

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
