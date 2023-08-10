provider "aws" {
    region = "ap-south-1"
  
}

 resource "aws_instance" "web" {
  ami           = "ami-0da59f1af71ea4ad2"
  instance_type = "t2.micro"
  keypair       = "demo"
  security_groups = ["demo-sg"]
  subnet_id = aws_subnet.demo-public_subent_01.id
 }

 resource "aws_instance" "db" {
  ami           = "ami-0da59f1af71ea4ad2"
  instance_type = "t2.micro"
  keypair       = "demo"
  security_groups = ["demo-sg"]
  subnet_id = aws_subnet.demo-private_subent_01.id
 }

 resource "aws_security_group" "demo-sg" {
  name        = "demo-sg"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
   
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
   }

  tags = {
    Name = "allow-sg"
  }
}

resource "aws_vpc" "demo-sg" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name ="dpw-vpc"
    }
}

//Create a Subnet 
resource "aws_subnet" "demo-public_subent_01" {
    vpc_id = aws_vpc.demo-sg.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "ap-south-1a"
    tags = {
      Name = "demo-public_subent_01"
    }
}

//Create a Subnet for private
resource "aws_subnet" "demo-private_subent_01" {
    vpc_id = aws_vpc.demo-sg.id
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "ap-south-1b"
    tags = {
      Name = "demo-private_subent_02"
    }
}

//Creating an Internet Gateway 
resource "aws_internet_gateway" "demo-igw" {
    vpc_id = aws_vpc.demo-sg.id
    tags = {
      Name = "demo-igw"
    }
}

// Create a route table 
resource "aws_route_table" "dpw-public-rt" {
    vpc_id = aws_vpc.demo-sg.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.demo-igw.id
    }
    tags = {
      Name = "dpw-public-rt"
    }
}

// Associate subnet with route table

resource "aws_route_table_association" "demo-rta-public-subent-1" {
    subnet_id = aws_subnet.demo-public_subent_01.id
    route_table_id = aws_route_table.demo-public-rt.id
}
