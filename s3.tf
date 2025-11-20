resource "aws_s3_bucket" "my_bucket"{
    bucket ="Terraform-Oneshot-Bucket-007"
    acl = "private"
}