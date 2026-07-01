output "vpc_id" {
  value = aws_vpc.it_tools_vpc.id
}

output "public_subnets_ids" {
  value = [aws_subnet.it_tools_public_subnet_1.id, aws_subnet.it_tools_public_subnet_2.id]
}

output "private_subnets_ids" {
  value = [aws_subnet.it_tools_private_subnet_1.id, aws_subnet.it_tools_private_subnet_2.id]
}