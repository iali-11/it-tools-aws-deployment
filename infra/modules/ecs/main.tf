resource "aws_ecs_cluster" "it_tools_cluster" {
  name = "it_tools_cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_iam_role" "ecs_task_role" {
  name = "ecsTaskRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = { Service = "ecs-tasks.amazonaws.com" }
      },
    ]
  })
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs_Task_Execution_Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = { Service = "ecs-tasks.amazonaws.com" }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attach" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = var.ecs_task_execution_role_policy_arn
}

resource "aws_cloudwatch_log_group" "ecs_logs" {
  name = "/ecs/it-tools-logs"
}

resource "aws_ecs_task_definition" "it_tools_task_definition" {
  family                   = "it_tools_task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([{
    name      = var.container_name
    image     = "${var.ecr_repository_url}:latest"
    essential = true
    portMappings = [
      {
        containerPort = var.app_port
        hostPort      = var.app_port
      }
    ]

    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.ecs_logs.name
        awslogs-region        = var.aws_region
        awslogs-stream-prefix = "ecs"
      }
    }
    }
  ])
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }
}

resource "aws_security_group" "ecs_container_sg" {
  name        = "ECS-it-tools-app-SG"
  description = "Allow inbound traffic from port 8080 and reference ALB SG"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "ecs_container_sg_rule" {
  type                     = "ingress"
  from_port                = var.app_port
  to_port                  = var.app_port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ecs_container_sg.id
  source_security_group_id = var.it_tools_alb_sg
}

resource "aws_vpc_security_group_egress_rule" "ecs_container_sg_outbound" {
  security_group_id = aws_security_group.ecs_container_sg.id
  cidr_ipv4         = var.default_cidr_block
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_ecs_service" "it_tools_ecs_service" {
  name             = "it-tools-ecs-service"
  cluster          = aws_ecs_cluster.it_tools_cluster.id
  task_definition  = aws_ecs_task_definition.it_tools_task_definition.arn
  desired_count    = 2
  launch_type      = "FARGATE"
  platform_version = "LATEST"

  network_configuration {
    subnets          = var.private_subnets_ids
    assign_public_ip = false
    security_groups  = [aws_security_group.ecs_container_sg.id]
  }

  load_balancer {
    target_group_arn = var.ip_it_tools_tg_arn
    container_name   = var.container_name
    container_port   = var.app_port
  }
}