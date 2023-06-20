data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}

module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"
  count  = 3

  name = "Het-instance-${count.index + 1}"

  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t2.micro"
  key_name                    = "het"
  vpc_security_group_ids      = [aws_security_group.sg[count.index].id]
  subnet_id                   = module.vpc.public_subnets[count.index]
  user_data                   = file("./user-data.sh")
  associate_public_ip_address = true

  ebs_block_device = [{
    device_name = "/dev/sdh"
    volume_size = 2
  }]

  tags = {
    Name  = "Het-instance-${count.index + 1}"
    Owner = "het.desai@intuitive.cloud"
  }
}