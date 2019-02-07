# Internet VPC
resource "aws_vpc" "harman" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    enable_classiclink = "false"
    tags {
        Name = "harman"
    }
}


# Subnets
resource "aws_subnet" "harman-public-1" {
    vpc_id = "${aws_vpc.harman.id}"
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-2a"

    tags {
        Name = "harman-public-1"
    }
}
resource "aws_subnet" "harman-public-2" {
    vpc_id = "${aws_vpc.harman.id}"
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-2b"

    tags {
        Name = "harman-public-2"
    }
}
resource "aws_subnet" "harman-public-3" {
    vpc_id = "${aws_vpc.harman.id}"
    cidr_block = "10.0.3.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-2c"

    tags {
        Name = "harman-public-3"
    }
}
resource "aws_subnet" "harman-private-1" {
    vpc_id = "${aws_vpc.harman.id}"
    cidr_block = "10.0.4.0/24"
    map_public_ip_on_launch = "false"
    availability_zone = "us-east-2a"

    tags {
        Name = "harman-private-1"
    }
}
resource "aws_subnet" "harman-private-2" {
    vpc_id = "${aws_vpc.harman.id}"
    cidr_block = "10.0.5.0/24"
    map_public_ip_on_launch = "false"
    availability_zone = "us-east-2b"

    tags {
        Name = "harman-private-2"
    }
}
resource "aws_subnet" "harman-private-3" {
    vpc_id = "${aws_vpc.harman.id}"
    cidr_block = "10.0.6.0/24"
    map_public_ip_on_launch = "false"
    availability_zone = "us-east-2c"

    tags {
        Name = "harman-private-3"
    }
}

# Internet GW
resource "aws_internet_gateway" "harman-gw" {
    vpc_id = "${aws_vpc.harman.id}"

    tags {
        Name = "harman"
    }
}

# route tables
resource "aws_route_table" "harman-public" {
    vpc_id = "${aws_vpc.harman.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.harman-gw.id}"
    }

    tags {
        Name = "harman-public-1"
    }
}

# route associations public
resource "aws_route_table_association" "harman-public-1-a" {
    subnet_id = "${aws_subnet.harman-public-1.id}"
    route_table_id = "${aws_route_table.harman-public.id}"
}
resource "aws_route_table_association" "harman-public-2-a" {
    subnet_id = "${aws_subnet.harman-public-2.id}"
    route_table_id = "${aws_route_table.harman-public.id}"
}
resource "aws_route_table_association" "harman-public-3-a" {
    subnet_id = "${aws_subnet.harman-public-3.id}"
    route_table_id = "${aws_route_table.harman-public.id}"
}

