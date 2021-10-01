output "region" {
    value = var.region
}

output "asg_name" {
    value = var.asg-name
}

output "asg_arn" {
    value = aws_autoscaling_group.asg-config.arn
}

output "green_listener_name" {
    value = aws_lb_listener.green_listener.id
}


output "green_listener_arn" {
    value = aws_lb_listener.green_listener.arn
}

output "green_listener_arn_rule" {
    value = aws_lb_listener_rule.green_listener_rule.arn
}

output "green_alb" {
//    value = var.green-alb
    value = aws_lb.green_lb.arn
}

output "green_tg_1_name" {
    value = var.green-tg-1
}

output "green_tg_1_arn" {
    value = aws_lb_target_group.green_tg_1.arn
}

output "green_tg_2_name" {
    value = var.green-tg-1
}

output "green_tg_2_arn" {
    value = aws_lb_target_group.green_tg_2.arn
}
/*
output "blue_alb" {
//    value = var.blue-alb
    value = aws_lb.blue_lb.arn
}

output "blue_tg_1" {
    value = aws_lb_target_group.blue_tg_1.arn
}

output "blue_tg_2" {
    value = aws_lb_target_group.blue_tg_2.arn
}

output "blue_listener" {
    value = aws_lb_listener.blue_listener.arn
}
*/