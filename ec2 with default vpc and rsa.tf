resource "tls_private_key" "nautilus_kp" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Save private key to file
resource "local_file" "nautilus_kp" {
  filename        = "/home/bob/nautilus-kp.pem"
  content         = tls_private_key.nautilus_kp.private_key_pem
  file_permission = "0600"
}

# Create AWS EC2 Key Pair
resource "aws_key_pair" "nautilus_kp" {
  key_name   = "nautilus-kp"
  public_key = tls_private_key.nautilus_kp.public_key_openssh
}

output "key_pair_name" {
  value = aws_key_pair.nautilus_kp.key_name
}
resource "aws_instance" "nautilus_ec2" {
  ami           = "ami-0c101f26f147fa7fd"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.nautilus_kp.key_name

  vpc_security_group_ids = [
    data.aws_security_group.default.id
  ]

  tags = {
    Name = "nautilus-ec2"
  }
}

data "aws_security_group" "default" {
  name = "default"
}

#Ami from exsting instance
# Fetch existing EC2 instance by Name tag
data "aws_instance" "nautilus_ec2"{
  filter {
    name= "tag:name"
    values =["nautilus-ec2"]
  }
}

resource "aws_ami_from_instance" nautilus_ec2"{
  name               = "nautilus-ec2-ami"
  source_instance_id = data.aws_instance.nautilus_ec2.id

  tags = {
    Name = ""nautilus-ec2-ami"
}
}
