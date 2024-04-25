provider "aws" {
  region = "ap-south-1"
}

resource "aws_iam_policy" cc-s3-policy {
  name        = "cc-s3-policy"
  description = "Allow read access to s3 buckets and write access to the cloudwatch logs"
  policy      = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:PutLogEvents",
          "logs:CreateLogGroup",
          "logs:CreateLogStream"
        ],
        "Resource" : "arn:aws:logs:*:*:*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject"
        ],
        "Resource" : "arn:aws:s3:::*/*"
      }
    ]
  })
}

# Creating a role for the lambda function to allow AWS resources on my behalf
resource "aws_iam_role" cc-s3-role {
  name               = "cc-s3-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
  description = "Allow lambda functions to access AWS services on my behalf"
}