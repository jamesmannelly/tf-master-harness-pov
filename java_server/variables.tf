variable "access_key" {}

variable "secret_key" {}

variable "region" {
    default= "eu-west-2"
}

variable "primary_zone_id" {
  default = "Z1PSCTOWTFWDHX"
}

variable "ami_image" {
  default = "ami-09eeb68276530f289"
}

variable "user_data_script" {
  default = <<EOF
#!/bin/bash
sudo yum install git curl unzip -y
sudo sh  /opt/bitnami/tomcat/bin/startup.sh
EOF
}