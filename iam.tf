resource "aws_iam_user" "terraform_user"{
    name = "terraform-user"
}

resource "aws_iam_group" "terraform_group"{
    name = "terraform-group"
}

resource "aws_iam_policy" "terraform_policy" {
  name = "terraform-policy"
  description = "Policy for Terraform User"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        #Action =["ec2:*", "s3:*", "vpc:*", "cloudwatch:*"]
        # Action = [
        #   "s3:ListBucket",
        #   "s3:GetObject",
        #   "s3:PutObject",
        #   "s3:DeleteObject"
        # ]
        # Resource = [
        #   aws_s3_bucket.my_bucket.arn,
        #   "${aws_s3_bucket.my_bucket.arn}/*"
        # ]
        Action = ["ec2.Describe*"]
        Resource = ["*"]
      }
    ]
  })
}
