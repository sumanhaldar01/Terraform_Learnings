resource "aws_s3_bucket" "my_bucket" {
    bucket ="Terraform-Oneshot-Bucket-007"
    acl = "private"
}
resource "aws_s3_bucket_versioning" "versioning" {
    bucket = aws_s3_bucket.my_bucket.id
    versioning_configuration {
        status = "Enabled"
    }
}
resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.my_bucket.id
  acl    = "private"
}
