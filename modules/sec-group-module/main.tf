resource "aws_security_group" "allow_trafic" {
  name        = "sr-allow_trafic"
  description = "Allow inbound traffic"
  # vpc_id      = var.vpc_id

    dynamic "ingress" {
        for_each = var.ports_list
        content {
            from_port = ingress.value["port"]
            to_port = ingress.value["port"]
            protocol = ingress.value["protocol"]
            cidr_blocks = [ingress.value["source"]]
        }
    }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "sr-sec"
  }
}