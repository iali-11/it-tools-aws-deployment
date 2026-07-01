output "it_tools_alb" {
  value = aws_lb.it_tools_alb.id
}

output "it_tools_alb_dns_name" {
  value = aws_lb.it_tools_alb.dns_name
}
output "it_tools_alb_zone_id" {
  value = aws_lb.it_tools_alb.zone_id
}

output "it_tools_alb_sg" {
  value = aws_security_group.it_tools_alb_sg.id
}

output "ip_it_tools_tg_arn" {
  value = aws_lb_target_group.ip_it_tools_tg.arn
}