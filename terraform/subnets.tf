# public subnet

resource "aws_subnet" "public" {

  count = length(var.public_subnets)

  vpc_id = aws_vpc.main.id

  cidr_block = var.public_subnets[count.index]

  availability_zone = var.availability_zones[count.index]

  map_public_ip_on_launch = true

  tags = {

    Name = "public-subnet-${count.index + 1}"

    "kubernetes.io/role/elb" = "1"

  }

}

# private subnets

resource "aws_subnet" "private" {

  count = length(var.private_subnets)

  vpc_id = aws_vpc.main.id

  cidr_block = var.private_subnets[count.index]

  availability_zone = var.availability_zones[count.index]

  tags = {

    Name = "private-subnet-${count.index + 1}"

    "kubernetes.io/role/internal-elb" = "1"

  }

}


