resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  assign_generated_ipv6_cidr_block = true

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "main_a" {
  cidr_block = "10.0.1.0/24"
  vpc_id = aws_vpc.main.id
  availability_zone = local.az_a
  ipv6_cidr_block = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, 1)

  tags = {
    Name = "main_a"
  }
}

resource "aws_subnet" "main_b" {
  cidr_block = "10.0.2.0/24"
  vpc_id = aws_vpc.main.id
  availability_zone = local.az_b
  ipv6_cidr_block = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, 2)

  tags = {
    Name = "main_b"
  }
}

resource "aws_subnet" "main_c" {
  cidr_block = "10.0.3.0/24"
  vpc_id = aws_vpc.main.id
  availability_zone = local.az_c
  ipv6_cidr_block = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, 3)

  tags = {
    Name = "main_c"
  }
}

// Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main_gw"
  }
}

// IPv4 route to internet
resource "aws_route" "vpc_web" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id = aws_vpc.main.main_route_table_id
  gateway_id = aws_internet_gateway.gw.id
}

// IPv6 route to internet
resource "aws_route" "vpc_web_ipv6" {
  destination_ipv6_cidr_block = "::/0"
  route_table_id = aws_vpc.main.main_route_table_id
  gateway_id = aws_internet_gateway.gw.id
}

resource "aws_security_group" "cpanel" {
  name = "cpanel"
  description = "cPanel Rules"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description = "Allow SSH"
  }

  ingress {
    from_port = -1
    protocol = "icmp"
    to_port = -1
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow Ping"
  }

  ingress {
    from_port = -1
    protocol = "icmpv6"
    to_port = -1
    ipv6_cidr_blocks = ["::/0"]
    description = "Allow Pingv6"
  }

  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port = 443
    protocol = "tcp"
    to_port = 443
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  # cPanel
  ingress {
    from_port = 2083
    protocol = "tcp"
    to_port = 2083
    ipv6_cidr_blocks = ["::/0"]
    cidr_blocks = ["0.0.0.0/0"]
    description = "cPanel admin access"
  }

  # WHM admin
  ingress {
    from_port = 2087
    protocol = "tcp"
    to_port = 2087
    ipv6_cidr_blocks = ["${local.ipv6_bart}/128"]
    cidr_blocks = ["${local.ip_bart}/32"]
    description = "WHM admin access"
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description = "Allow Internet Access"
  }
}
