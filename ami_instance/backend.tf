terraform {
   backend "s3" {
   bucket = "bic-harness"
   key = "terraform-ami-instance.tfstate"
   region = "eu-west-2"
  }
}