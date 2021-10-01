resource "aws_instance" "web_server" {
  ami                    = var.ami_image
  instance_type          = "t2.micro"
  user_data              = data.template_file.user_data.rendered
  key_name               = "bc-harness"
  vpc_security_group_ids = ["sg-01c4818eac2729203"]
  
  tags = {
    Name        = "WebServer"
    Environment = "Production"
  }
}

resource "aws_eip" "wb_eip" {
  instance = aws_instance.web_server.id
  vpc      = true
}

resource "aws_route53_record" "www" {
  zone_id = var.primary_zone_id
  name    = "www.bicatana.net"
  type    = "A"
  ttl     = "300"
  records = ["${aws_eip.wb_eip.public_ip}"]
}

