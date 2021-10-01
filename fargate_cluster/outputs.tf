output "clusterName" {
    value = aws_ecs_cluster.ecs-cluster.name
}

output "region" {
    value = var.region
}