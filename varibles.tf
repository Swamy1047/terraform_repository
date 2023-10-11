variable "region_name" {
  default = "ap-southeast-1"  
}

variable "bucket_name" {
    default = "aws-file-storage-bucket1047"  
}

variable "vpc_cidr" {
    default = "10.0.0.0/16"      
}

variable "public_subnet_cidr" {
    default = "10.0.1.0/24"      
}

variable "private_subnet_cidr" {
    default = "10.0.2.0/24"      
}

variable "database_subnet_cidr" {
    default = "10.0.3.0/24"      
}