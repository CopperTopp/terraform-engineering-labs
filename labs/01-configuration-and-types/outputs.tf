output "vpc_id" {
  description = "ID of the lab VPC."
  value       = aws_vpc.lab.id
}

output "public_subnet_id" {
  description = "Public subnet IDs keyed by subnet identifier"
  value = {
    for key, subnet in aws_subnet.lab : key => subnet.id
  }
}