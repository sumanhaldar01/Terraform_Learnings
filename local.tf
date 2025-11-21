resource "local_file" "test"{
    content = "This is local file using terraform"
    filename = "Autofile_Terraform.txt"
}

# terraform state commands

# terraform state list # lists all resources in the state file
# terraform state show <resource_name> # shows detailed info about a specific resource
# terraform state rm <resource_name> # removes a resource from the state file
# terraform state mv <source> <destination> # moves or renames a resource in the state file

# terraform import <resource_name> <resource_id> # imports an existing resource into the state file
# Example:
# terraform import aws_instance.my_instance i-1234567890abcdef0

