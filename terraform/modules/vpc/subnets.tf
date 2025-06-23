resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name           = "${var.environment}-public-subnet-${count.index + 1}",
    Environment    = var.environment,
    Owner          = var.owner,
    Project        = var.project,
    Classification = var.classification
  })
}

resource "aws_subnet" "private_subnets" {
  count                   = length(var.private_subnet_cidrs)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = merge(var.tags, {
    Name           = "${var.environment}-private-subnet-${count.index + 1}",
    Environment    = var.environment,
    Owner          = var.owner,
    Project        = var.project,
    Classification = var.classification
  })
}
