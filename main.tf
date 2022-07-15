# data source for ec2
# ami-id: ami-078a289ddf4b09ae0
data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm*"]
  }
}

# resources
resource "aws_vpc" "kt-tf" {
  cidr_block           = var.vpc-cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = local.my_tags

}

resource "aws_subnet" "kt-public-subnet1" {
  cidr_block              = var.psub-cidr
  vpc_id                  = aws_vpc.kt-tf.id
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws-region}a"

  tags = merge(local.my_tags, { Name = "${var.res-name}-sub1" })

}

resource "aws_internet_gateway" "kt-igw" {
  vpc_id = aws_vpc.kt-tf.id
  tags   = merge(local.my_tags, { Name = "${var.res-name}-igw" })

}

resource "aws_route_table" "kt-rtb" {
  vpc_id = aws_vpc.kt-tf.id
  tags   = merge(local.my_tags, { Name = "${var.res-name}-rtb" })
}

resource "aws_route" "kt-rt" {
  route_table_id         = aws_route_table.kt-rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.kt-igw.id
}

resource "aws_route_table_association" "kt-rta-1" {
  #aws_route      = aws_route.route.rt.id
  subnet_id      = aws_subnet.kt-public-subnet1.id
  route_table_id = aws_route_table.kt-rtb.id
}

resource "aws_security_group" "kt-sg" {
  description = "security group for nginx web server"
  vpc_id      = aws_vpc.kt-tf.id

  ##access to webserver
  ingress {
    cidr_blocks = ["${var.my-ip}"]
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
  }

  ingress {
    cidr_blocks = ["${var.my-ip}"]
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }

  ##outbound from webserver
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  #tags = local.my_tags
  tags = merge(local.my_tags, { Name = "${var.res-name}-pub-sg" })
}

#ssh public key for ec2
resource "aws_key_pair" "kt-key" {
  key_name   = "ktkey"
  public_key = file("~/.ssh/ktkey.pub")

}

resource "aws_instance" "kt-ec2-nginx" {
  ami             = data.aws_ami.amazon-linux-2.id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.kt-sg.id]
  subnet_id       = aws_subnet.kt-public-subnet1.id
  key_name        = aws_key_pair.kt-key.key_name
  user_data       = file("userdata.tpl")

  #tags = local.my_tags
  tags = merge(local.my_tags, { Name = "${var.res-name}-nginx1" })

}


