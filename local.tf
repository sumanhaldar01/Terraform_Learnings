resource "local_file" "test"{
    content = "This is local file using terraform"
    filename = "Autofile_Terraform.txt"
}