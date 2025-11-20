variable "ec2_instance_type" {
  description = "Type of AWS EC2 instance"
  type        = string
  default     = "t3.large"
}
variable "ec2_root_volume_size" {
  description = "Size of the root volume for AWS EC2 instance in GB"
  type        = number
  default     = 15
}

variable "ec2_ami_id" {
  description = "AMI ID for the AWS EC2 instance"
  type        = string
  default     = "ami-0f8e81a3da6e2510a" # Ubuntu Server 20.04 LTS (HVM), SSD Volume Type
}