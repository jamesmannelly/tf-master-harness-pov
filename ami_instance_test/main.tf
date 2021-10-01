resource "aws_launch_configuration" "bg-launch-config" {
  name                        = var.launch_config_name
  image_id                    = var.ami_image
  instance_type               = "t4g.micro"
  security_groups             = ["sg-01c4818eac2729203"]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg-config" {
  name                 = var.asg-name
  min_size             = 1
  desired_capacity     = 1
  max_size             = 3
  health_check_type    = "EC2"
  launch_configuration = aws_launch_configuration.bg-launch-config.name
  vpc_zone_identifier  = ["subnet-8abbfee3"]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb" "green_lb" {
  load_balancer_type = "application"
  name               = var.green-alb
  subnets            = ["subnet-8abbfee3","subnet-d7b2659b"]
}

resource "aws_lb_target_group" "green_tg_1" {
  name          = var.green-tg-1
  port          = 80
  protocol      = "HTTP"
  target_type   = "instance"
  vpc_id        = "vpc-d7fa89bf"
  stickiness {
      type = "lb_cookie"
      enabled = true
      cookie_duration = 1
  }
}

resource "aws_lb_target_group" "green_tg_2" {
  name          = var.green-tg-2
  port          = 80
  protocol      = "HTTP"
  target_type   = "instance"
  vpc_id        = "vpc-d7fa89bf"
  stickiness {
      type = "lb_cookie"
      enabled = true
      cookie_duration = 1
  }
}

resource "aws_lb_listener" "green_listener" {
  load_balancer_arn = aws_lb.green_lb.arn

  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    forward {
        stickiness {
            enabled = true
            duration = 1
        }
        target_group {
          arn = aws_lb_target_group.green_tg_1.arn
          weight = 100
        }
        target_group {
            arn = aws_lb_target_group.green_tg_2.arn
            weight = 0
        }
    }
  }
}

resource "aws_lb_listener_rule" "green_listener_rule" {
  listener_arn = aws_lb_listener.green_listener.arn

  action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.green_tg_1.arn
        weight = 100
      }

      target_group {
        arn    = aws_lb_target_group.green_tg_2.arn
        weight = 0
      }
      stickiness {
        enabled  = true
        duration = 1
      }
    }
  }

  condition {
    host_header {
      values = ["*.*.*"]
    }
  }
}


//////////// SAMPLE SETUP
/*
resource "aws_elb" "blue_alb" {
  name    = var.blue-alb
  subnets = ["subnet-8abbfee3"]
 
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }
}
*/
/*
resource "aws_lb" "blue_lb" {
  load_balancer_type = "application"
  name               = var.blue-alb
  subnets            = ["subnet-8abbfee3","subnet-d7b2659b"]
}

resource "aws_lb_listener" "blue_listener" {
  load_balancer_arn = aws_lb.blue_lb.arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    forward {
        target_group {
          arn = aws_lb_target_group.blue_tg_1.arn
        }
        target_group {
            arn = aws_lb_target_group.blue_tg_2.arn
        }
    }
  }
}

resource "aws_lb_target_group" "blue_tg_1" {
  name          = var.blue-tg-1
  port          = 8080
  protocol      = "HTTP"
  target_type   = "instance"
  vpc_id        = "vpc-d7fa89bf"
}

resource "aws_lb_target_group" "blue_tg_2" {
  name          = var.blue-tg-2
  port          = 8080
  protocol      = "HTTP"
  target_type   = "instance"
  vpc_id        = "vpc-d7fa89bf"
}
*/