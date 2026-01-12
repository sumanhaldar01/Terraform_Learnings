resource "aws_iam_user" "test"{
  name = "iam_suman"
}
resource "aws_iam_group" "test"{
  name = "iam_devops"
}
resource "aws_iam_policy" "policy" {
  name        = "ec2_readonly_policy"
  #path        = "/"
  #description = "My test policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
