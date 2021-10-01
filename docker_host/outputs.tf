output "region" {
    value = var.region
}

output "publicdns" {
    value = aws_instance.docker_host.public_dns
}

output "publicip" {
    value = aws_instance.docker_host.public_ip
}