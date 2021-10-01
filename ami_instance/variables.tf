variable "access_key" {}

variable "secret_key" {}

variable "green-alb" {
  default = "alb-1"
}

variable "asg-name" {
  default = "asg-1"
}

variable "launch_config_name" {
  default = "lc-1"
}

variable "green-tg-1" {
  default = "tg-1-1"
}

variable "green-tg-2" {
  default = "tg-1-2"
}

variable "green-listener" {
  default = "listener-1"
}

variable "region" {
  default = "eu-west-2"
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