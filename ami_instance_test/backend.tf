terraform {
   backend "s3" {
   bucket = "bic-harness"
   key = "terraform-ami-2.tfstate"
   region = "eu-west-2"
  }
}