# Security Group for EC2 instances
resource "aws_security_group" "ec2_security_group" {
  name        = "${var.environment}-ec2-security-group"
  description = "Security group for EC2 instances in ${var.environment} environment"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name           = "${var.environment}-ec2-security-group"
    Environment    = var.environment
    Owner          = var.owner
    Project        = var.project
    Classification = var.classification
  })
}
