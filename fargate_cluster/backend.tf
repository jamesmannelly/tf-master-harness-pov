terraform {
   backend "s3" {
   bucket = "bic-harness"
   key = "tf-fargate-cluster.tfstate"
   region = "eu-west-2"
  }
}