variable "vpc_id" {
  type = string
}

variable "public_subnets_ids" {
  type = list(string)
}

variable "private_subnets_ids" {
  type = list(string)
}

variable "default_cidr_block" {
  type = string
}

variable "app_port" {
  type = number
}

variable "acm_cert_arn" {
  type = string
}