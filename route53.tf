resource "aws_route53_zone" "g4o_infra" {
  name = "g4o-infra.nl"
  tags = {
    Name = "g4o-infra.nl"
  }
}

resource "aws_route53_record" "cp1" {
  name = "cp1"
  type = "A"
  zone_id = aws_route53_zone.g4o_infra.id
  ttl = "300"
  records = [aws_eip.cpanel_public_1.public_ip]
}

resource "aws_route53_record" "cp1_ipv6" {
  name = "cp1"
  type = "AAAA"
  zone_id = aws_route53_zone.g4o_infra.id
  ttl = 300
  records = [aws_instance.cpanel.ipv6_addresses[0]]
}
