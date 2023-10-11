terraform {
  backend "s3" {
    bucket = "tfstate-file-storage-bucket"
    key = "mykey/TF"
    region = "ap-southeast-1"    
  }
}