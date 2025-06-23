resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(var.tags, {
    Name           = "${var.environment}-internet-gateway",
    Environment    = var.environment,
    Owner          = var.owner,
    Project        = var.project,
    Classification = var.classification
  })
}
