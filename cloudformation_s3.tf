resource "aws_cloudformation_stack" "test" {
  name = "terraform-stack"

  template_body = <<EOF
{
  "AWSTemplateFormatVersion": "2010-09-09",
  "Resources": {
    "TestBucket": {
      "Type": "AWS::S3::Bucket",
      "Properties": {
        "BucketName": "test-bucket-23081",
        "VersioningConfiguration": {
          "Status": "Enabled"
        }
      }
    }
  }
}
EOF
}
