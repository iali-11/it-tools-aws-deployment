variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block of VPC"
}

variable "public_subnet_cidr_blocks" {
  type        = list(string)
  description = "CIDR block of public subnets"
}

variable "private_subnet_cidr_blocks" {
  type        = list(string)
  description = "CIDR block of private subnets"
}

variable "availability_zones" {
  type = list(string)
}

variable "default_cidr_block" {
  type = string
}