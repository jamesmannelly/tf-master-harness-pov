terraform {
   backend "s3" {
   bucket = "bic-harness"
   key = "terraform-web-server.tfstate"
   region = "eu-west-2"
  }
}