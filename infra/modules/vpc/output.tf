output "vpc_id" {
  value = aws_vpc.it_tools_vpc.id
}

output "public_subnets_ids" {
  value = aws_subnet.it_tools_public_subnets[*].id
}

output "private_subnets_ids" {
  value = aws_subnet.it_tools_private_subnets[*].id
}