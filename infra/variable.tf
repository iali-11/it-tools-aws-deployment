variable "vpc_cidr_block" {
  type = string
  default = "10.0.0.0/22"
}

variable "public_subnet_1_cidr_block" {
  type = string
  default = "10.0.0.0/25"
}

variable "public_subnet_2_cidr_block" {
  type = string
  default = "10.0.1.0/25"
}

variable "private_subnet_1_cidr_block" {
  type = string
  default = "10.0.2.0/25"
}

variable "private_subnet_2_cidr_block" {
  type = string
  default = "10.0.3.0/25"
}

variable "availability_zone_1" {
  type = string
  default = "eu-west-2a"
}

variable "availability_zone_2" {
  type = string
  default = "eu-west-2b"
}

variable "default_cidr_block" {
  type = string
  default = "0.0.0.0/0"
}

variable "container_name" {
  type = string
  default = "it-tools-app"
}

variable "cpu" {
  type = number
  default = 256
}

variable "memory" {
  type = number
  default = 512
}

variable "ecs_task_execution_role_policy_arn" {
  type = string
  default = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

variable "aws_region" {
  type = string
  default = "eu-west-2"
}

variable "it_tools_domain_name_root" {
  type = string
  default = "tm-ibrahimali.com"
}

variable "it_tools_domain_name_www" {
  type = string
  default = "www.tm-ibrahimali.com"
}

variable "ecr_repository_url" {
  type = string
  default = "050288151438.dkr.ecr.eu-west-2.amazonaws.com/it_tools_app"
}

variable "app_port" {
  type = number
  default = 8080
}

variable "image_tag" {
  type = string
  default = "latest"
}