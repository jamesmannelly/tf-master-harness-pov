# Creating a VPC 
resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr}"
  tags = {
    Name = "${var.vpc_name}"
  }
}

#---------VPC Attachment-----------------------------------
resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_tgway_attachment" {
  subnet_ids         = [aws_subnet.PublicSubnet1.id, aws_subnet.PublicSubnet2.id, aws_subnet.PublicSubnet3.id]
  transit_gateway_id = "${var.transit_gateway_id}"
  vpc_id             = aws_vpc.main.id
  tags = {
    "Name" = "${var.transit_gateway_attachment_name}"
  }
}

resource "aws_default_route_table" "route" {
  default_route_table_id  = aws_vpc.main.default_route_table_id
  route = [{
      "cidr_block": "0.0.0.0/0",
      "destination_prefix_list_id": "",
      "egress_only_gateway_id": "",
      "gateway_id": "",
      "instance_id": "",
      "ipv6_cidr_block": "",
      "nat_gateway_id": "",
      "network_interface_id": "",
      "transit_gateway_id": "${var.transit_gateway_id}",
      "vpc_endpoint_id": "",
      "vpc_peering_connection_id": ""
    }
  ]
  tags = {
    Name = "Route table association"
  }
  depends_on = [
    aws_vpc.main,
    aws_ec2_transit_gateway_vpc_attachment.vpc_tgway_attachment
  ]
}

resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.main.id
  route = []
  tags = {
    Name = "private Route table association"
  }
  depends_on = [
    aws_vpc.main,
    aws_ec2_transit_gateway_vpc_attachment.vpc_tgway_attachment
  ]
}

resource "aws_route_table_association" "private_route_table_association_1" {
  subnet_id      = aws_subnet.PrivateSubnet1.id
  route_table_id = aws_route_table.private_route.id
}

resource "aws_route_table_association" "private_route_table_association_2" {
  subnet_id      = aws_subnet.PrivateSubnet2.id
  route_table_id = aws_route_table.private_route.id
}

resource "aws_route_table_association" "private_route_table_association_3" {
  subnet_id      = aws_subnet.PrivateSubnet3.id
  route_table_id = aws_route_table.private_route.id
}

resource "aws_route_table_association" "private_route_table_association_4" {
  subnet_id      = aws_subnet.PrivateSubnet4.id
  route_table_id = aws_route_table.private_route.id
}

#---------------------------------ROUTE53 RULES ASSOCIATION----------------

resource "aws_route53_resolver_rule_association" "addr_arpa" {
  resolver_rule_id = "${var.route53_addr_arpa}"
  vpc_id           = aws_vpc.main.id
}


#---------------------------------SUBNET CREATION---------------------------

# Create subnets for AZ1
resource "aws_subnet" "PrivateSubnet1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "${var.private_subnet_cidr_1}"
  availability_zone = "${var.availability_zone_1}"
  tags = {
    Name = "Subnet1stAZ"
  }
}

resource "aws_subnet" "PublicSubnet1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "${var.public_subnet_cidr_1}"
  availability_zone = "${var.availability_zone_1}"
  map_public_ip_on_launch = false
  tags = {
    Name = "TGW-Subnet1stAZ"
    "kubernetes.io/cluster/${var.EKS_cluster_name}" = "owned"
  }
}

# Create subnets for AZ2
resource "aws_subnet" "PublicSubnet2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "${var.public_subnet_cidr_2}"
  availability_zone = "${var.availability_zone_2}"
  map_public_ip_on_launch = false
  tags = {
    Name = "TGW-Subnet2ndAZ"
    "kubernetes.io/cluster/${var.EKS_cluster_name}" = "owned"
  }
}

resource "aws_subnet" "PrivateSubnet2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "${var.private_subnet_cidr_2}"
  availability_zone = "${var.availability_zone_2}"
  tags = {
    Name = "Subnet2ndAZ"
  }
}

# Create subnets for AZ3

resource "aws_subnet" "PublicSubnet3" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "${var.public_subnet_cidr_3}"
  availability_zone = "${var.availability_zone_3}"
  map_public_ip_on_launch = false
  tags = {
    Name = "TGW-Subnet3rdAZ"
    "kubernetes.io/cluster/${var.EKS_cluster_name}" = "owned"
  }
}

resource "aws_subnet" "PrivateSubnet3" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "${var.private_subnet_cidr_3}"
  availability_zone = "${var.availability_zone_3}"
  tags = {
    Name = "Subnet3rdAZ"
  }
}

resource "aws_subnet" "PrivateSubnet4" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "${var.private_subnet_cidr_4}"
  availability_zone = "${var.availability_zone_1}"
  tags = {
    Name = "Subnet1stAZ"
  }
}

#-------------------------------SECURITY GROUP CREATION----------------------

# Private security group. Allows only local traffic
resource "aws_security_group" "Private" {
  name        = "private-sg"
  vpc_id = aws_vpc.main.id
  ingress = [
    {
      description      = "TLS from VPC"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["${var.vpc_cidr}"]
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]
  egress = [
    {
      description      = "TLS from VPC"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["${var.vpc_cidr}"]
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]
  tags = {
    Name = "PrivateSecurityGroup"
  }
}

# Public Security group. Allows all traffic
resource "aws_security_group" "public_allow_outgoing" {
  name        = "allow_outgoing"
  description = "Allow TLS, ssh inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id
  ingress = [
    {
      description      = "TLS from VPC"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
      ipv6_cidr_blocks = ["::/0"]
    },
    {
      description      = "SSH to VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
      ipv6_cidr_blocks = ["::/0"]
    },
    {
      description      = "allow all incoming traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
      ipv6_cidr_blocks = ["::/0"]
    }
  ]
  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      description      = "Outbound rule to allow all traffic"
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]
  tags = {
    Name = "allow_tls"
  }
}

#-----------------------------------NACL CREATION----------------------------

# Private NACL creation
resource "aws_network_acl" "private_nacl" {
  vpc_id = aws_vpc.main.id
  subnet_ids = [aws_subnet.PrivateSubnet1.id, aws_subnet.PrivateSubnet2.id, aws_subnet.PrivateSubnet3.id]
  egress = [
    {
      protocol   = "tcp"
      rule_no    = 200
      action     = "allow"
      cidr_block = "${var.vpc_cidr}"
      from_port  = 0
      to_port    = 0
      icmp_code  = null
      icmp_type  = null
      ipv6_cidr_block  = null
    }
  ]
  ingress = [
    {
      protocol   = "tcp"
      rule_no    = 100
      action     = "allow"
      cidr_block = "${var.vpc_cidr}"
      from_port  = 0
      to_port    = 0
      icmp_code  = null
      icmp_type  = null
      ipv6_cidr_block  = null
    }
  ]
  tags = {
    Name = "Terraform"
  }
}

# Public NACL creation
resource "aws_network_acl" "public_nacl" {
  vpc_id = aws_vpc.main.id
  subnet_ids = [aws_subnet.PublicSubnet1.id, aws_subnet.PublicSubnet2.id, aws_subnet.PublicSubnet3.id]
  egress = [
    {
      protocol   = -1
      rule_no    = 200
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
      icmp_code  = null
      icmp_type  = null
      ipv6_cidr_block  = null
    }
  ]
  ingress = [
    {
      protocol   = -1
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
      icmp_code  = null
      icmp_type  = null
      ipv6_cidr_block  = null
    }
  ]
  tags = {
    Name = "Terraform"
  }
}

#-----------------------OUTPUTS----------------------

output "vpc_id" {
  value = "${aws_vpc.main.id}"
  }

output "aws_route_table_id" {
  value = "${aws_default_route_table.route.id}"
  }

output "aws_subnet_PublicSubnet1" {
  value = "${aws_subnet.PublicSubnet1.id}"
  }

output "aws_subnet_PublicSubnet2" {
  value = "${aws_subnet.PublicSubnet2.id}"
  }

output "aws_subnet_PublicSubnet3" {
  value = "${aws_subnet.PublicSubnet3.id}"
  }

output "public_allow_outgoing" {
  value = "${aws_security_group.public_allow_outgoing.id}"
  }

output "vpc_cidr_block" {
  value = "${aws_vpc.main.cidr_block}"
  }