# EC2 Instances
resource "aws_instance" "ec2_instances" {
  count         = var.instance_count
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = element(var.subnet_ids, count.index)
  key_name      = var.key_name
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]
  associate_public_ip_address = true

  root_block_device {
    volume_type           = "gp3"
    delete_on_termination = false
    volume_size           = 30

    # Add tags to the root volume here
    tags = merge(var.tags, {
      Name           = "${var.environment}-ec2-root-volume-${count.index + 1}"
      Environment    = var.environment
      Owner          = var.owner
      Project        = var.project
      Classification = var.classification
    })
  }

  tags = merge(var.tags, {
    Name           = "${var.environment}-ec2-instance-${count.index + 1}"
    Environment    = var.environment
    Owner          = var.owner
    Project        = var.project
    Classification = var.classification
  })
}
