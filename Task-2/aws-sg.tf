resource "aws_security_group" "sg" {
  count       = 3
  name        = "Het-sg-${count.index}"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.vpc.vpc_id

  dynamic "ingress" {

    for_each = [
      { type = "tcp", from_port = 80, to_port = 80, cidr_blocks = ["0.0.0.0/0"] },
      { type = "tcp", from_port = 22, to_port = 22, cidr_blocks = ["0.0.0.0/0"] }
    ]
    content {
      from_port   = ingress.value["from_port"]
      to_port     = ingress.value["to_port"]
      protocol    = ingress.value["type"]
      cidr_blocks = ingress.value["cidr_blocks"]
    }

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Het-sg-${count.index}"
  }
}
