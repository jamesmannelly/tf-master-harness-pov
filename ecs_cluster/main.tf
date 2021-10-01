

resource "aws_ecs_cluster" "ecs-cluster" {
    name = var.ecs-cluster-name

}

  resource "aws_autoscaling_group" "ecs-autoscaling-group" {
    name                        = "ecs-asg-${var.ecs-cluster-name}"
    max_size                    = "3"
    min_size                    = "1"
    desired_capacity            = var.capacity
    vpc_zone_identifier         = var.subnets
    launch_configuration        = "${aws_launch_configuration.ecs-launch-configuration.name}"
    health_check_type           = "ELB"
  }
  resource "aws_launch_configuration" "ecs-launch-configuration" {
    name                        = "ecs-lb-${var.ecs-cluster-name}"
    image_id                    = "ami-0e4249602c03f799a"
    instance_type               = "m5d.large"
    iam_instance_profile        = "ECSRoleForEC2"
    root_block_device {
      volume_type = "standard"
      volume_size = 30
      delete_on_termination = true
    }
    lifecycle {
      create_before_destroy = true
    }
    security_groups             = var.security_groups
    associate_public_ip_address = "true"
    key_name                    = "bc-harness"
    user_data                   = "#!/bin/bash\necho ECS_CLUSTER='${var.ecs-cluster-name}' > /etc/ecs/ecs.config"
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