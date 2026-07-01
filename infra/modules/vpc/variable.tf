variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block of VPC"
}

variable "public_subnet_1_cidr_block" {
  type        = string
  description = "CIDR block of public subnet 1"
}

variable "public_subnet_2_cidr_block" {
  type        = string
  description = "CIDR block of public subnet 2"
}

variable "private_subnet_1_cidr_block" {
  type        = string
  description = "CIDR block of private subnet 1"
}

variable "private_subnet_2_cidr_block" {
  type        = string
  description = "CIDR block of private subnet 2"
}

variable "availability_zone_1" {
  type = string
}

variable "availability_zone_2" {
  type = string
}

variable "default_cidr_block" {
  type = string
}