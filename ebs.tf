resource "aws_ebs_volume" "test_volume" {
    availability_zone = "eu-north-1a"
    size = 15
    type = "gp3"
    tags ={
        Name = "Terraform-EBS-Volume"
    }
}

resource "aws_ebs_snapshot" "test_snapshot"{
  volume_id = aws_ebs_volume.test_volume.id
  description = "Datacenter Snapshot"
  tags = {
    Name = "datacenter-vol-ss"
  }
}
