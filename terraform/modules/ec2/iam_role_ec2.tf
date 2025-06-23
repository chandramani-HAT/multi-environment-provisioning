resource "aws_iam_role" "ec2_ecr_access_role" {
  name = "${var.environment}-ec2-ecr-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })

  tags = merge(var.tags, {
    Name           = "${var.environment}-ec2-ecr-access-role",
    Environment    = var.environment,
    Owner          = var.owner,
    Project        = var.project,
    Classification = var.classification
  })
}

resource "aws_iam_policy" "ec2_ecr_access_policy" {
  name        = "${var.environment}-ec2-ecr-access-policy"
  description = "Policy to allow EC2 instances to pull images from ECR"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      }
    ]
  })

  tags = merge(var.tags, {
    Name           = "${var.environment}-ec2-ecr-access-policy",
    Environment    = var.environment,
    Owner          = var.owner,
    Project        = var.project,
    Classification = var.classification
  })
}

resource "aws_iam_role_policy_attachment" "ec2_ecr_access_attach" {
  role       = aws_iam_role.ec2_ecr_access_role.name
  policy_arn = aws_iam_policy.ec2_ecr_access_policy.arn
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${var.environment}-ec2-instance-profile"
  role = aws_iam_role.ec2_ecr_access_role.name
}
