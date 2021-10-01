terraform {
  backend "gcs" {
    bucket  = "harness-bootcamp"
    prefix  = "terraform/state"
  }
}