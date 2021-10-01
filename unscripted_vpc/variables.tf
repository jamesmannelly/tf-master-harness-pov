variable "access_key" {}

variable "secret_key" {}

variable "environment" {}

variable "region" {
    default= "eu-west-2"
}

variable "cidr" {
    default = "10.0.0.0/16"
}