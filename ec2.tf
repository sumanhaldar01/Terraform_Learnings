#Key pair
resource aws_key_pair my_test_key {
    key_name = "terra-key-ec2"
    public_key = file("terra-key-ec2.pub")
}

#VPC & Subnet
resource aws_vpc my_vpc{
    cidr_block = "10.0.0.0/16" # CIDR stands for Classless Inter-Domain Routing
    assign_generated_ipv6_cidr_block = true #enable IPv6
    tags = {
    Name = "Terraform-vpc"
  }
}
resource "aws_subnet" "my_subnet" {
    vpc_id     = aws_vpc.my_vpc.id
    cidr_block = "10.0.1.0/24"

    tags = {
      Name = "Terraform-subnet"
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "Terraform-igw"
  }
}

resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block      = "0.0.0.0/0" #internet access
    gateway_id      = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "Terraform-route-table"
  }
}

resource "aws_route_table_association" "my_route_table_association" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_route_table.id
}

#Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.2.0/24"

  tags = {
    Name = "Terraform-private-subnet"
  }
}

#Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"
  
  tags = {
    Name = "Terraform-nat-eip"
  }

  depends_on = [aws_internet_gateway.my_igw]
}

#NAT Gateway in Public Subnet
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.my_subnet.id

  tags = {
    Name = "Terraform-nat-gateway"
  }

  depends_on = [aws_internet_gateway.my_igw]
}

#Route Table for Private Subnet
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "Terraform-private-route-table"
  }
}

#Route Table Association for Private Subnet
resource "aws_route_table_association" "private_route_table_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

#For reference, to use the default VPC instead of creating a new one.
# data "aws_vpc" "default" {
#   default = true
# }
#Security Group

resource "aws_security_group" "my_sg" {
    name = "Terraform-sg"
    description = "this is TF generated security group"
    vpc_id = aws_vpc.my_vpc.id #interpolation syntax
    # vpc_id = data.aws_vpc.default.id #if using default VPC
    
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "allow SSH access from anywhere"
    }
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "allow HTTP access from anywhere"
    }

    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "allow HTTPS access from anywhere"
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1" #all traffic
        cidr_blocks = ["0.0.0.0/0"]
        description = "allow all outbound traffic"
    }
}

#EC2 Instance
resource "aws_instance" "my_instance"{

    #count = 3 #to create multiple instances (META-ARGUMENT)

    #for_each = toset(["instance1","instance2","instance3"]) #alternative way to create multiple instances

    for_each = tomap({
      "instance1" = "t2.micro",
      "instance2" = "t3.large",
    })

    depends_on = [ aws_key_pair.my_test_key, aws_security_group.my_sg ]

    ami= var.ec2_ami_id
    #instance_type = var.ec2_instance_type
    instance_type = each.value  # when using for_each
    key_name = aws_key_pair.my_test_key.key_name
    vpc_security_group_ids = [
    aws_security_group.my_sg.id
    ]
    subnet_id = aws_subnet.my_subnet.id
    user_data = file("nginx_install.sh")
    root_block_device {
      #volume_size = var.ec2_default_root_volume_size
      volume_size = var.environment == "prod" ? 20 : var.ec2_default_root_volume_size #conditional expression
      volume_type = "gp3"
    }
    tags ={
      #Name ="Terraform-EC2-instance"
      Name = each.key  # or "Terraform-EC2-${each.key}"
    }
}

resource aws_instance another_instance {  #example of importing existing resource 
    ami = "unknown"
    instance_type = "unknown"
 

}
