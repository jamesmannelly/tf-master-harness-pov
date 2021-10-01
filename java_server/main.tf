resource "aws_instance" "java_server" {
  ami                    = var.ami_image
  instance_type          = "t2.micro"
  user_data              = var.user_data_script
  key_name               = "bc-harness"
  vpc_security_group_ids = ["sg-01c4818eac2729203"]
  
  tags = {
    Name        = "JavaServer"
    Environment = "Production"
  }
}

resource "aws_eip" "jv_eip" {
  instance = aws_instance.java_server.id
  vpc      = true
}

resource "aws_route53_record" "www" {
  zone_id = var.primary_zone_id
  name    = "www.bicatana.net"
  type    = "A"
  ttl     = "300"
  records = ["${aws_eip.jv_eip.public_ip}"]
}

