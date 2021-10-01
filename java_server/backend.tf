terraform {
   backend "s3" {
   bucket = "bic-harness"
   key = "terraform-java-server.tfstate"
   region = "eu-west-2"
  }
}