resource "null_resource" "backup_and_delete_s3_bucket" {

  provisioner "local-exec" {
    command = <<EOT
      set -e

      echo "Creating local backup directory if it does not exist..."
      mkdir -p /opt/s3-backup/

      echo "Copying contents of S3 bucket to local directory..."
      aws s3 sync s3://bucket-name-here /opt/s3-backup/

      echo "Deleting S3 bucket and all its contents..."
      aws s3 rb s3://bucket-name-here --force

    EOT
  }
}
