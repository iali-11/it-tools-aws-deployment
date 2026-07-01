resource "aws_security_group" "it_tools_alb_sg" {
  name        = "it_tools_alb_sg"
  description = "Allow inbound traffic from port 80/443 and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "it_tools_alb_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.it_tools_alb_sg.id
  cidr_ipv4         = var.default_cidr_block
  description       = "Allow inbound HTTP traffic"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.it_tools_alb_sg.id
  cidr_ipv4         = var.default_cidr_block
  description       = "Allow inbound HTTPS traffic"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.it_tools_alb_sg.id
  cidr_ipv4         = var.default_cidr_block
  description       = "Allow all outbound traffic"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_lb" "it_tools_alb" {
  name                       = "it-tools-alb"
  internal                   = false
  load_balancer_type         = "application"
  subnets                    = var.public_subnets_ids
  security_groups            = [aws_security_group.it_tools_alb_sg.id]
  drop_invalid_header_fields = true

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "ip_it_tools_tg" {
  name        = "ip-it-tools-tg"
  port        = var.app_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
}



resource "aws_lb_listener" "it_tools_listener" {
  load_balancer_arn = aws_lb.it_tools_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "it_tools_listener_https" {
  load_balancer_arn = aws_lb.it_tools_alb.arn
  port              = "443"
  protocol          = "HTTPS"

  ssl_policy = "ELBSecurityPolicy-TLS-1-2-2017-01"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ip_it_tools_tg.arn
  }

  certificate_arn = var.acm_cert_arn
}