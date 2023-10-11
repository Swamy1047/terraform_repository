resource "aws_s3_bucket" "my-bucket" {
    bucket = var.bucket_name  
}

resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr

    instance_tenancy = "default"
    enable_dns_hostnames = true
    enable_dns_support = true
    
    tags = {
      Name = "My-VPC"
      Environment = "Dev"
      Terraform = "true"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id  
}

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.public_subnet_cidr
    map_public_ip_on_launch = true
    availability_zone = "ap-southeast-1a"

    tags = {
      Name = "Public-Subnet"
      Environment = "Dev"
    }
}

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.main.id

    route {
        gateway_id = aws_internet_gateway.igw.id
        cidr_block = "0.0.0.0/0"        
    }  

    tags = {
      Name = "Public-RT"
      Environment = "Dev"
    }
}

resource "aws_route_table_association" "public" {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_rt.id      
}

resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.private_subnet_cidr
    map_public_ip_on_launch = false
    availability_zone = "ap-southeast-1b"

    tags = {
      Name = "Private-Subnet"
      Environment = "Dev"
    }
}

resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.main.id

    
    tags = {
      Name = "Private-RT"
      Environment = "Dev"
    }
}

resource "aws_route_table_association" "private" {
    subnet_id = aws_subnet.private_subnet.id
    route_table_id = aws_route_table.private_rt.id      
}

resource "aws_subnet" "database_subnet" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.database_subnet_cidr
    map_public_ip_on_launch = false
    availability_zone = "ap-southeast-1c"

    tags = {
      Name = "Database-Subnet"
      Environment = "Dev"
    }
}

resource "aws_route_table" "database_rt" {
    vpc_id = aws_vpc.main.id

    
    tags = {
      Name = "Database-RT"
      Environment = "Dev"
    }
}

resource "aws_route_table_association" "database" {
    subnet_id = aws_subnet.database_subnet.id
    route_table_id = aws_route_table.database_rt.id      
}

resource "aws_eip" "elp" {
    domain   = "vpc"
}
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.elp.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "my_vpc-nat_gw"
   
  }  
}

resource "aws_route" "private" {
  route_table_id            = aws_route_table.private_rt.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
  depends_on                = [aws_route_table.private_rt]
}

resource "aws_route" "database" {
  route_table_id            = aws_route_table.database_rt.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
  depends_on                = [aws_route_table.database_rt]
}

resource "aws_instance" "web_server" {
    subnet_id = aws_subnet.public_subnet.id
    instance_type = var.instance_type
    ami = var.ami_id

    tags = {
      Name = "Web-server"
      Environment = "Dev"
      Terraform = "true"
    }
  
}
