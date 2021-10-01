variable "access_key" {}

variable "secret_key" {}

variable "environment" {}

variable "provisionEC2" {
    default = "no"
}

variable "primary_zone_id" {}

variable "region" {
    default= "eu-west-2"
}