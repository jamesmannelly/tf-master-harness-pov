# Creating EKSCluster
resource "aws_eks_cluster" "NewInfra" {
  name     = "${var.EKS_cluster_name}"
  role_arn = "${var.EKS_iam_role_arn}"
  vpc_config {
    subnet_ids = ["${var.public_subnet_1}", "${var.public_subnet_3}", "${var.public_subnet_2}"]
    # security_group_ids = [ "${var.public_allow_outgoing}" ]
    # endpoint_private_access = true
    # endpoint_public_access = true
  }
  tags = {
    Name = "${var.EKS_cluster_name}"
    env =  "Dev"
  }
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.NewInfra.name
  addon_name   = "vpc-cni"
}

# Outputs of the above EKS Cluster
output "endpoint" {
  value = aws_eks_cluster.NewInfra.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.NewInfra.certificate_authority[0].data
}

# Create EKS nodes.

resource "aws_eks_node_group" "Node_Group" {
  cluster_name    = "${aws_eks_cluster.NewInfra.name}"
  node_group_name = "${var.node_group_name}"
  node_role_arn   = "${var.EKS_node_group_role_arn}"
  subnet_ids      = ["${var.public_subnet_1}", "${var.public_subnet_3}", "${var.public_subnet_2}"]
  disk_size = "${var.EKS_disk_size}"
  scaling_config {
    desired_size = "${var.EKS_desired_size}"
    max_size     = "${var.EKS_max_size}"
    min_size     = "${var.EKS_min_size}"
  } 
  instance_types = "${var.EKS_instance_type}"
  tags = {
    Name  = "${var.EKS_cluster_name}"
    "kubernetes.io/cluster/${var.EKS_cluster_name}" = "owned"
  }
}