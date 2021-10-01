terraform {
   backend "s3" {
   bucket = "bic-harness"
   key = "terraform-ecs-cluster.tfstate"
   region = "eu-west-2"
  }
}