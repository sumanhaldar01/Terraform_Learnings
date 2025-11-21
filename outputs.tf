# output "ec2_instance_id" {
#   description = "ID of the EC2 instance"
#   value       = aws_instance.my_instance[*].id #[*] to get all instances when count is used remove [*] for single instance
# }
# output "ec2_public_ip" {
#   description = "Public IP address of the EC2 instance"
#   value       = aws_instance.my_instance[*].public_ip
# }
# output "ec2_public_dns" {
#   description = "Public DNS of the EC2 instance"
#   value       = aws_instance.my_instance[*].public_dns
# }
# output "ec2_private_ip" {
#   description = "Private IP address of the EC2 instance"
#   value       = aws_instance.my_instance[*].private_ip
# }

# When using for_each to create multiple instances
output "ec2_instance_ids" {
  value = [
    for key in aws_instance.my_instance : key.id
  ]
}
output "ec2_instance_ips" {
  value = [
    for key in aws_instance.my_instance : key.private_ip
  ]
}