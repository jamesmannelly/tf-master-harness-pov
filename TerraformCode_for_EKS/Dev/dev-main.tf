variable "statefile_backend_bucket" {}
variable "statefile_key" {}
variable "region" {}
variable "env_tag" {}

terraform {
  backend "s3"  {
    bucket = "${var.statefile_backend_bucket}"
    key = "${var.statefile_key}"
    region = "${var.region}"
  }
}

provider "aws" {
  region = "${var.region}"
  default_tags {
   tags = {
     env    =   "${var.env_tag}"
     "Created By"   =   "Terraform"
   }
 }
}

variable "vpc_cidr" {}
variable "availability_zone_1" {}
variable "availability_zone_2" {}
variable "availability_zone_3" {}
variable "private_subnet_cidr_1" {}
variable "private_subnet_cidr_2" {}
variable "private_subnet_cidr_3" {}
variable "private_subnet_cidr_4" {}
variable "transit_gateway_id" {}
variable "public_subnet_cidr_1" {}
variable "public_subnet_cidr_2" {}
variable "public_subnet_cidr_3" {}
variable "vpc_name" {}
variable "transit_gateway_attachment_name" {}
variable "route53_addr_arpa" {}

module "vpc" {
    source = "../modules/vpc"
    transit_gateway_id = "${var.transit_gateway_id}"
    vpc_cidr = "${var.vpc_cidr}"
    availability_zone_1 = "${var.availability_zone_1}"
    availability_zone_2 = "${var.availability_zone_2}"
    availability_zone_3 = "${var.availability_zone_3}"
    private_subnet_cidr_1 = "${var.private_subnet_cidr_1}"
    private_subnet_cidr_2 = "${var.private_subnet_cidr_2}"
    private_subnet_cidr_3 = "${var.private_subnet_cidr_3}"
    private_subnet_cidr_4 = "${var.private_subnet_cidr_4}"
    public_subnet_cidr_1 = "${var.public_subnet_cidr_1}"
    public_subnet_cidr_2 = "${var.public_subnet_cidr_2}"
    public_subnet_cidr_3 = "${var.public_subnet_cidr_3}"
    vpc_name = "${var.vpc_name}"
    EKS_cluster_name  = "${var.EKS_cluster_name}"
    transit_gateway_attachment_name = "${var.transit_gateway_attachment_name}"
    route53_addr_arpa = "${var.route53_addr_arpa}"
}

variable "EKS_instance_type" {}
variable "EKS_min_size" {}
variable "EKS_max_size" {}
variable "EKS_desired_size" {}
variable "EKS_disk_size" {}
variable "EKS_cluster_name" {}
variable "node_group_name" {}

module "eks" {
    source = "../modules/eks"
    public_subnet_1 = "${module.vpc.aws_subnet_PublicSubnet1}"
    public_subnet_2 = "${module.vpc.aws_subnet_PublicSubnet2}"
    public_subnet_3 = "${module.vpc.aws_subnet_PublicSubnet3}"
    public_allow_outgoing = "${module.vpc.public_allow_outgoing}"
    EKS_iam_role_arn    =   "${module.iam.EKS_iam_role_arn}"
    EKS_node_group_role_arn =   "${module.iam.EKS_node_group_role_arn}"
    EKS_desired_size = "${var.EKS_desired_size}"
    EKS_min_size = "${var.EKS_min_size}"
    EKS_max_size = "${var.EKS_max_size}"
    EKS_disk_size = "${var.EKS_disk_size}"
    EKS_instance_type = "${var.EKS_instance_type}"
    EKS_cluster_name = "${var.EKS_cluster_name}"
    node_group_name = "${var.node_group_name}"
    depends_on = [module.iam]
}

variable "EKS_iam_role_name" {}
variable "EKS_Node_Group_role_name" {}

module "iam" {
    source = "../modules/iam"
    EKS_Node_Group_role_name = "${var.EKS_Node_Group_role_name}"
    EKS_iam_role_name  = "${var.EKS_iam_role_name}"
}

variable "s3_bucket_name_for_monitoring" {}

module "s3" {
    source = "../modules/s3"
    s3_bucket_name_for_monitoring  = "${var.s3_bucket_name_for_monitoring}"
}

#-------------------------------Resources specific to ENV--------------------------------


#-------------------------VPC_Flow_Logs-------------------------------

resource "aws_flow_log" "VPCFlowLogs-dev" {
  iam_role_arn    = aws_iam_role.VPCFlowLogsIAM-dev.arn
  log_destination = aws_cloudwatch_log_group.VPCLogGroup-dev.arn
  traffic_type    = "ALL"
  vpc_id          = "${module.vpc.vpc_id}"
}


resource "aws_cloudwatch_log_group" "VPCLogGroup-dev" {
  name = "VPCLogGroup-dev"
}

resource "aws_iam_role" "VPCFlowLogsIAM-dev" {
  name = "VPCFlowLogs-dev"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "VPCFlowLogsPolicy-dev" {
  name = "VPCFlowLogsPolicy-dev"
  role = aws_iam_role.VPCFlowLogsIAM-dev.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}


