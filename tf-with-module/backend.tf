terraform {
   backend "s3" {
   bucket = "bic-harness"
   key = "terraform-ec2-module.tfstate"
   region = "eu-west-2"
  }
}