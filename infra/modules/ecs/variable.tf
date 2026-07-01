variable "it_tools_alb" {
  type = string
}

variable "it_tools_alb_sg" {
  type = string
}

variable "ip_it_tools_tg_arn" {
  type = string
}

variable "private_subnets_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "cpu" {
  type = number
}

variable "memory" {
  type = number
}

variable "ecs_task_execution_role_policy_arn" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "default_cidr_block" {
  type = string
}

variable "container_name" {
  type = string
}

variable "ecr_repository_url" {
  type = string
}

variable "app_port" {
  type = number
}

variable "image_tag" {
  type = string
}