variable "access_key" {}

variable "secret_key" {}

variable "green-alb" {
  default = "alb-2"
}

variable "asg-name" {
  default = "asg-2"
}

variable "launch_config_name" {
  default = "lc-2"
}

variable "green-tg-1" {
  default = "tg-2-1"
}

variable "green-tg-2" {
  default = "tg-2-2"
}

variable "green-listener" {
  default = "listener-2"
}

variable "region" {
    default= "eu-west-2"
}

variable "primary_zone_id" {
  default = "Z1PSCTOWTFWDHX"
}

variable "ami_image" {
  default = "ami-0b55aac867940e735"
}

/*
variable "blue-alb" {
  default = "blue-alb"
}

variable "blue-tg-1" {
  default = "blue-tg-1"
}

variable "blue-tg-2" {
  default = "blue-tg-2"
}
*/