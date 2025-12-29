terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.91.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}
# Generate RSA private key
resource "tls_private_key" "datacenter_kp" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Save private key to file
resource "local_file" "datacenter_kp_pem" {
  filename        = "/home/bob/datacenter-kp.pem"
  content         = tls_private_key.datacenter_kp.private_key_pem
  file_permission = "0600"
}

# Create AWS EC2 Key Pair
resource "aws_key_pair" "datacenter_kp" {
  key_name   = "datacenter-kp"
  public_key = tls_private_key.datacenter_kp.public_key_openssh
}

output "key_pair_name" {
  value = aws_key_pair.datacenter_kp.key_name
}
