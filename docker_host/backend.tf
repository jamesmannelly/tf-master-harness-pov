terraform {
   backend "s3" {
   bucket = "bic-harness"
   key = "terraform-docker-host.tfstate"
   region = "eu-west-2"
  }
}