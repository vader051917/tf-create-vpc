# Create vpc
resource "aws_vpc" "vpc" {
  cidr_block       = "10.0.0.0/22"
  instance_tenancy = "default"

  tags = {
    Name = var.vpc_name
  }
}

#Create subnets
resource "aws_subnet" "subnets" {
  for_each   = var.subnet_config
  vpc_id     = aws_vpc.vpc.id
  cidr_block = each.value
  tags = {
    Name = each.key
  }
  map_public_ip_on_launch = each.key == "public_subnet" ? true : false
  availability_zone       = var.subnet_az[each.key]
}

#Create IG
resource "aws_internet_gateway" "vpc-ig" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "ig-${var.vpc_name}"
  }

}

#Create route table and add route to IG
resource "aws_route_table" "public-route" {
  vpc_id = aws_vpc.vpc.id

  dynamic "route" {
    for_each = var.public_routes
    iterator = cidr
    content {
      cidr_block = cidr.value
      gateway_id = aws_internet_gateway.vpc-ig.id
    }

  }
}

#Associate public subnet to new route table that has route to IG
resource "aws_route_table_association" "public-rt-assc" {
  subnet_id      = aws_subnet.subnets["public_subnet"].id
  route_table_id = aws_route_table.public-route.id
}

# Create sec group in publis subnet with ssh and http
resource "aws_security_group" "sg-public-ec2" {
  name = "allows_ssh_http"

  dynamic "ingress" {
    for_each = var.sg_ports
    iterator = ports
    content {
      from_port   = ports.value
      to_port     = ports.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.vpc.id
}


# Add a security group rule for default sec group created with vpc

resource "aws_vpc_security_group_ingress_rule" "private-sg-ingress" {
  security_group_id = aws_vpc.vpc.default_security_group_id

  referenced_security_group_id = aws_security_group.sg-public-ec2.id

  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
}

#Create key for ec2
resource "tls_private_key" "generate-ssh-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private-key" {
  content  = tls_private_key.generate-ssh-key.private_key_openssh
  filename = "tf-mkp-private.pem"
}

resource "aws_key_pair" "ec2-key-pair" {
  key_name   = "tf-mkp"
  public_key = tls_private_key.generate-ssh-key.public_key_openssh
}
