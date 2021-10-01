variable "access_key" {}

variable "secret_key" {}

variable "region" {
    default= "eu-west-2"
}

variable "ecs-cluster-name" {}

variable "capacity" {
  default = "2"
  }

variable "subnets" {
    default = ["subnet-8abbfee3"]
}

variable "security_groups" {
    default = ["sg-01c4818eac2729203"]
}

variable "green-alb" {
  default = "alb-ecs"
}

variable "green-tg-1" {
  default = "tg-ecs-1"
}

variable "green-tg-2" {
  default = "tg-ecs-2"
}

variable "green-listener" {
  default = "listener-ecs"
}