output "region" {
    value = var.region
}

output "publicdns" {
    value = aws_instance.web_server.public_dns
}

output "publicip" {
    value = aws_instance.web_server.public_ip
}